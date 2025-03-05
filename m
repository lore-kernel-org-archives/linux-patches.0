Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE63119DF61;
	Wed,  5 Mar 2025 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197265; cv=none; b=b2KvhHdJBP/GiJsxVyXaT68xft5naz921k7htnsvi6vuzPubxYOkQZ7xzmik8uO5NbuLuzFkSs6zVZ/TerFsInherEFI+AgQxbuLZlQJQxbkcGSKHO1iBdylbnQcXXUDikVcUPQsGYEM+FE6GfeV37dMMYCmIfS8qV7Gzau6Bjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197265; c=relaxed/simple;
	bh=bIpxcgAbe80BLMO+J0q7VqBKhjVjmgGiL78XUdCt238=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iatebtOMgcY6d+j1GUwPM+VQK87bj+wJVylpGq20p7zX4IUdQHeGICHcmS6ZCICmqAUoTWPKSFvl5ZL49EPonvDrJBQzGrXBUgkmyDXgZ5+fPCVSDkdfs8lSj4/K8jt32x1pCGY6qO+gOqjowFHr0OvFVS0u1jjGg1WoSOUlGqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPYTD7gP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPYTD7gP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B36C4CED1;
	Wed,  5 Mar 2025 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197265;
	bh=bIpxcgAbe80BLMO+J0q7VqBKhjVjmgGiL78XUdCt238=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPYTD7gPxmxSBzqt2vIxuVWpLISnKJcBRDZ2OeQ5NJKlbX9J0qg1zkra65n1WcTuX
	 h0K4cczymt2pMByfOqDDc6QGxbmcrRYxY0RO4vhFl78/FrCK8U8eDtQiOskK9HGeRR
	 nQzUUPmggVljnvgIdZbpi2nfGXYlel6keELDHaYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 095/176] spi: atmel-quadspi: Fix wrong register value written to MR
Date: Wed,  5 Mar 2025 18:47:44 +0100
Message-ID: <20250305174509.277613253@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Dahl <ada@thorsis.com>

commit 162d9b5d2308c7e48efbc97d36babbf4d73b2c61 upstream.

aq->mr should go to MR, nothing else.

Fixes: 329ca3eed4a9 ("spi: atmel-quadspi: Avoid overwriting delay register settings")
Signed-off-by: Alexander Dahl <ada@thorsis.com>
Link: https://lore.kernel.org/linux-spi/20240926-macarena-wincing-7c4995487a29@thorsis.com/T/#u
Link: https://patch.msgid.link/20240926090356.105789-1-ada@thorsis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/atmel-quadspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -390,7 +390,7 @@ static int atmel_qspi_set_cfg(struct atm
 	 */
 	if (!(aq->mr & QSPI_MR_SMM)) {
 		aq->mr |= QSPI_MR_SMM;
-		atmel_qspi_write(aq->scr, aq, QSPI_MR);
+		atmel_qspi_write(aq->mr, aq, QSPI_MR);
 	}
 
 	/* Clear pending interrupts */


