Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB20203710;
	Fri,  6 Dec 2024 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497997; cv=none; b=T4aU7Ap5qTDu+hJQShjP21ra2cgC913YWXIg5aqePXC1SILNjsbCxw68b3xAwwsILdoj15tx01d2XnZ3R3/t5dpy4RTaBu69FeG7RA5vOAIU2jRTH4Q1hbwkCaVTrst7pe6AGUMo/b/fQv0+LlfwfWTMe3ITlB+gRei3dUIki+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497997; c=relaxed/simple;
	bh=7GLcVC24rd4Qq9OLbF4cB0UGf5bseR0Zf7WyAy4xFH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YOO7vssA+9eRxOpR1P9LsN2oGBXmv7f3wI9tZ1FABDwQMNxbGiFdB0tdHBH81rj5DdHEAgr46OlrhQ6le0UUhfm2dd/smF8J+i8+3iVy49qqFirddGDe1uvKgnpHF4UStJ6wywgg4g6dBXhwZikKv3xWAF3kqh9I/RJXOaeIBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scgFN86F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scgFN86F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBD5C4CED1;
	Fri,  6 Dec 2024 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497996;
	bh=7GLcVC24rd4Qq9OLbF4cB0UGf5bseR0Zf7WyAy4xFH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scgFN86FSvLLHe+Vj9IJ+pBK1HLOWw6HxK32ccT8IYJqlk5bLixRL/bomvcPDcFui
	 160jPPD7qKeUAyXzKrNRcl9eUnAsUlg8SqHFrvwACZM0OGX9cKuIxeYAF4JMTb9hu8
	 OuVmrtuh3dzr/oZVWSAM4PPvEJpGJYjIm55OzJIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 414/676] spi: atmel-quadspi: Fix register name in verbose logging function
Date: Fri,  6 Dec 2024 15:33:53 +0100
Message-ID: <20241206143709.515902194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit 2ac40e6d0ccdd93031f8b1af61b0fe5cdd704923 ]

`atmel_qspi_reg_name()` is used for pretty-printing register offsets
for verbose logging of register accesses. However, due to a typo
(likely a copy-paste error), QSPI_RD's offset prints as "MR", the
name of the previous register. Fix this typo.

Fixes: c528ecfbef04 ("spi: atmel-quadspi: Add verbose debug facilities to monitor register accesses")
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Alexander Dahl <ada@thorsis.com>
Link: https://patch.msgid.link/20241122141302.2599636-1-csokas.bence@prolan.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 6f9e9d8716775..e7ae7cb4b92a8 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -183,7 +183,7 @@ static const char *atmel_qspi_reg_name(u32 offset, char *tmp, size_t sz)
 	case QSPI_MR:
 		return "MR";
 	case QSPI_RD:
-		return "MR";
+		return "RD";
 	case QSPI_TD:
 		return "TD";
 	case QSPI_SR:
-- 
2.43.0



