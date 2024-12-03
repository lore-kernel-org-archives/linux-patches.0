Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3251A23CE;
	Tue,  3 Dec 2024 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241994; cv=none; b=qS3ettTHqT3ynTv6Nx75Wuk1jeGFiZYxHfpMPSo7h6Gi6MrLC3gLQT16Z/LQLwL0H7Gsh87hPfrfm74yzZy/Hr0uBb/wzyRbxqNbJtJWnv2j220dlrMGDani970Uoweo+Xu++/cMAhzd8Izp1o1Nk262RR4Me1KGF8YAEIsuNV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241994; c=relaxed/simple;
	bh=2FYK1ONZUuE3hw46bOXum9v4bV2bxeaJohu87y9aqCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HVzMA6xCY37bW4YUb7e5ebnyxaesLWamXDmzVjbgSD9WAsTNlQmcgDBJGoR1suWGmsDsZoaDrd2xzo08Zeq5K7POk5osKb7i9Lpojr/xWH7RuztgBcfa2kZQB1j7BYOg1CTvnnApaeX0UTV7qqev1sogLEbqZr53gKI1M2VV75U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTa65SOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTa65SOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947C7C4CECF;
	Tue,  3 Dec 2024 16:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241994;
	bh=2FYK1ONZUuE3hw46bOXum9v4bV2bxeaJohu87y9aqCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTa65SOfWfwwzv2GrB1HDKczAe7L9aukP08Ge9Wg2FlwRVtJZVc+uXp9z87xq+M4V
	 aLAMHcvJrPtrp3uv1P6YXoYtQ2kbuWyQRTogT+Jq1S61Jk71QHoAx3H88RlGdlM0Sx
	 mKl+cwfRElvviw9GTjZPtU7RKYlZ3vA//7PUkqvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 575/826] spi: atmel-quadspi: Fix register name in verbose logging function
Date: Tue,  3 Dec 2024 15:45:02 +0100
Message-ID: <20241203144806.180283165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 95cdfc28361ef..caecb2ad2a150 100644
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



