Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C059D3BB5A;
	Fri, 17 Oct 2025 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714250; cv=none; b=LRsGdIuWoWmUCShoBL3aUG7VRQbn9+KlVQfiSN7doo+nKolvGETPYfTit4ed1wLq4LVg2Dy8d2gEFggcuxrOgK9/H39oouuXmmJfwB0BrtRfl1WBwmBdKomC5c0UdZvKNHdJ9MM5lfZMu9dC/ubD3RmsKbLCmdQO6BsfwKFrRSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714250; c=relaxed/simple;
	bh=xtZKABeWYS5pAHjnXA09bqrlHtbPzMJsgy8M3WlzoxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb+GA1aD7Uw/Wttw39W1gy9NbdX8h+ybJbBJubV57BOAofXuX44a1qIJv+1EBcEOpHgsidtUgu1VlHxUF8oNmKuxloVfN4UODJkmriW2S2mdUtuRHJnxT/2eqJ3+j1umpjtbrK2Kl1BRHiDUXRx9qf5HfQcyoRY7sMU2xmByywo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCZWjALP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCZWjALP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484C1C4CEE7;
	Fri, 17 Oct 2025 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714250;
	bh=xtZKABeWYS5pAHjnXA09bqrlHtbPzMJsgy8M3WlzoxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCZWjALPQFY8YzSw4DnqFzEKzllnv3oWdb65y3aCYPyVe1h8JBdP8nG8bYUl62Q7T
	 l1pT/JfUjlqguLGV127hIJWbp/Hn7KeIR8m8rD65zkVzy3/bFZUJ78Hgy4zP4cF4xC
	 hxQcZZElzq4KMW/YkkxYibr5u6oYfsXqS1kLILWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/277] tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single
Date: Fri, 17 Oct 2025 16:51:27 +0200
Message-ID: <20251017145150.057004831@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gunnar Kudrjavets <gunnarku@amazon.com>

[ Upstream commit 8a81236f2cb0882c7ea6c621ce357f7f3f601fe5 ]

The tpm_tis_write8() call specifies arguments in wrong order. Should be
(data, addr, value) not (data, value, addr). The initial correct order
was changed during the major refactoring when the code was split.

Fixes: 41a5e1cf1fe1 ("tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant phy")
Signed-off-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index ed0d3d8449b30..59e992dc65c4c 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -977,8 +977,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	 * will call disable_irq which undoes all of the above.
 	 */
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-		tpm_tis_write8(priv, original_int_vec,
-			       TPM_INT_VECTOR(priv->locality));
+		tpm_tis_write8(priv, TPM_INT_VECTOR(priv->locality),
+			       original_int_vec);
 		rc = -1;
 	}
 
-- 
2.51.0



