Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B9F53365;
	Thu, 12 Dec 2024 16:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022596; cv=none; b=YnIcEqF3EWF/pqXqmjBF/K5ntc5vJVSKfck8osyyrQrkuUs2G5cuhTFZDbGgDKEYsTGjp7iGe4UYQ38TE9jYg0PANkhHtyeG1oQ3vsKPwZo4G0mz0qNUzjJPjwTGio6H2x5Ug9JMj+/2VYteiUN1Io8ajBW6UUTyImS0Gv6GtWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022596; c=relaxed/simple;
	bh=bxKf3qR3tt9n14pQ4jWXe3YEU4sIE4AvJ6gwQclvpx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8ss+A/MpbAR5FmBpWINqgQU8sYnU/p/KJQNB9DOXCT4xccb3O98G/v3RFH0CqpYqiaQ7DoqTaq/DAezr2AKVz4m7uVjJbY+IwdFQmPEvaHN3V4ej3QihD1LKv9hQuV1noQUGjT4vR0JCbyzDQr03/wN3zCg9wcJgtn88Eer0Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3n3TNT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3n3TNT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF56C4CECE;
	Thu, 12 Dec 2024 16:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022594;
	bh=bxKf3qR3tt9n14pQ4jWXe3YEU4sIE4AvJ6gwQclvpx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3n3TNT+ErUXa3AD3vdcTWb/iAjxLiKas3Z2gvKYsYdBll+0JpK17sr1MispMUCRj
	 T5aN6x4Hpa7zfpXPZMl2F7siB9tQEOM3J0wxG0Gugj6LYuU1JKztp9VlqsfMn1pGmQ
	 q7ht+Yl5/I96baOwhcrn5Wcp+njl+SfXpYk381HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/565] spi: atmel-quadspi: Fix register name in verbose logging function
Date: Thu, 12 Dec 2024 15:57:57 +0100
Message-ID: <20241212144322.600013113@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 938017a60c8ed..0a4d060a71065 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -182,7 +182,7 @@ static const char *atmel_qspi_reg_name(u32 offset, char *tmp, size_t sz)
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



