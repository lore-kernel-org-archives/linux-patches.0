Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0B237FD3;
	Thu, 12 Dec 2024 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019854; cv=none; b=W3Ut3pLBvk0hHlEuwtiNu/Uv0vlHaqYe9ElXVWXI9r0oTw8FOAeRUuEpPQxwgMWgejqKTUZk2v94QzP4c9vJlyv3lxZpykeqr4xENQ1xtEoLKU5mdZ2BZlrh8OZLndQCXNPXBSvIRRoJP93mH8HxtkVeyv/tAxXQ+1A40ZgZHtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019854; c=relaxed/simple;
	bh=iANmz/qIuLDy5WcOI6eiW7hF+AYnMMRPCtRSgTtTFNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etof27l8H9AjXljrUpdhyr348h0vn7Z0Uwbxe3s+us0XO/DGWGFpO8V61uxM+jRVvtNUcg++iWAuoSaU0CMdHiGvIQ8t3cQMjn2Zl8qr3lccJDWU+0iR9RhAXUuO15PrnfisXgbogzWdYuRJtNDf0f1TaVhPEeW/wFFGTXUmNyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOm/CCqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOm/CCqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39646C4CED0;
	Thu, 12 Dec 2024 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019853;
	bh=iANmz/qIuLDy5WcOI6eiW7hF+AYnMMRPCtRSgTtTFNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOm/CCqV79CaXaHuDm2Jh5coblfasfKrnef695d5v5B4XL8cMl+dxUF/tqyRmtnK6
	 wJXgaLzn71LE+G0tQy8epdm0qOWqLwBC+EehpQiXhLvHpLLZ5ktpGiacQa7VbXsu2t
	 t9PANnJL2vx5Keu59fIi5tTpATzrgTfKFYbNE9IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 315/772] spi: atmel-quadspi: Fix register name in verbose logging function
Date: Thu, 12 Dec 2024 15:54:20 +0100
Message-ID: <20241212144402.906881710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d96c40e7c8123..b5afe5790b1d2 100644
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



