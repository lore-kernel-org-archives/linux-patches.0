Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619862;
	b=1w5/8dpcxheGvl7lnkGhCrg1gLv1d+/JIsp6CwPBvItrpPkXSog6n6BySZuB/uwhD6kG
	 j/fLbI/9991+lG5/DN1T1wmh0sFieszg03226M0I/xQMb9npoIf3J9JbiyWFiR5kS2kKI
	 B90C2NZOjgu3UIbjxmSbo7Ii2ZZsDkKvqDEa0D38IDrd6yglpIv6+0hqjgMzQ/nbrBlJQ
	 w66L8KFJdic8ARB7AMltcDM8nu/cM6hIJWTdDOrOkOOESjXU7xvQRa2++Dz3CFJT7Zj16
	 xC2/y8vjglPLf0a2LV5o7e4pludyUKiS7oYpm/yDe0ywOlC1vx4a5l77pRBFBCFbEgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vo7deBsiQgt9i6Ry+6HjURk4Z06zeg5n0Vby6YiQ/co=;
	b=mTvTf7MHghdQUjyd2DSa+TlEMnH3dzKbF/X108zKaHSlSAFQNYy/nsACCQsV9kdjAJgG
	 ckW9ZpM+A/t3himkzpTiH5mmC+zofwcZAbbuI67jfcvHBzA9g/+Caxv/Sv41tNJuZfi1C
	 OXwfj31Mg2zDBdqh/GDwlfyeXyo5Ko3tk0l4RVAQ7/jmbK4vIzMpulbJ2s3n4yVJdoae6
	 AVG7wxc4mbuu2JjUlZtjf3SyHSvbYILOj3lU/fWYktEsIAtv+589sBZBrSXAzIFkBxKV+
	 1dq40gVMEwOGr8OPqWk2P0C388dmmLIfMEboCyIe/c01b9wFGO6wrqr5yHenuIZWDgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ts4YSb6j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2737606A31E;
	Wed, 25 Nov 2026 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ts4YSb6j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ECD1F000C4;
	Wed, 25 Nov 2026 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619862;
	bh=vo7deBsiQgt9i6Ry+6HjURk4Z06zeg5n0Vby6YiQ/co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ts4YSb6jUzwL7Uf5adpvx5yM/IcHacAYspWvNq+ZgUq87UW66b6g9jC13gZhvDo9L
	 MTy/Dsm9kEAdaLk8xZwAyrWd+zdQ/lw0CovbDvN3EsYAyNTeCKDHg2/D7UchbRzIlS
	 CPZisc5l6yZ9BBeB+SYgQF074WuUAjWifxDuJRkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Gilmore <dennis@ausil.us>,
	Kees Cook <kees@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 0730/1005] spi: axi-spi-engine: Start the program length at zero
Date: Wed, 25 Nov 2026 15:34:28 +0100
Message-ID: <20261125143838.861995673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 2a490521d74ac76e5eb3c9a69d928a4c76dd3f78 upstream.

spi_engine_optimize_message() allocates the program with kzalloc_flex(),
which sets the __counted_by() counter "length" to the allocated size when
the compiler supports __builtin_counted_by_ref(). The program is then
filled by spi_engine_program_add_cmd(), which increments "length" and
stores at length - 1, expecting it to start at zero as it did when the
program came from kzalloc().

Reset "length" after the allocation, since it is a "usage" counter, not
a "total allocation" counter.

Build tested ARCH=x86_64 defconfig with CONFIG_SPI_AXI_SPI_ENGINE=m and
W=1, with GCC 16.2.0.

Reported-by: Dennis Gilmore <dennis@ausil.us>
Closes: https://lore.kernel.org/all/20261112025252.71375-1-dennis@ausil.us/
Fixes: 69050f8d6d075 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20261113065508.i.606-kees@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-axi-spi-engine.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index ead5b295e680..9cfee409f15c 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -818,6 +818,8 @@ static int spi_engine_optimize_message(struct spi_message *msg)
 	p = kzalloc_flex(*p, instructions, p_dry.length + 1);
 	if (!p)
 		return -ENOMEM;
+	/* spi_engine_program_add_cmd() counts the instructions as it adds them. */
+	p->length = 0;
 
 	spi_engine_compile_message(msg, false, p);
 
-- 
2.56.1



