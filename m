Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B86D1F75A4;
	Tue,  3 Dec 2024 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239440; cv=none; b=bsxYGUsE/N/xgFrEktEJp77lNaE946Jvj/jIQweQLGvOpFMwo/lZEsv3JTyCSbIb3uk/kAu5UnahK8WfpaHb8u3P0M/g1TANp/2kDb978phX5zYKB58uO9CRfIqia5bigHfKmd3r0Y1HdMm9hWJ9ZKHSGgT/TC7pS2pmeKw8VBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239440; c=relaxed/simple;
	bh=wfIOiBmG+EyBddZHyDJUKkHC/SxxwZ7Y6U+1NJQ9A6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPq6dcxcV8eDVjQh7YB82U3dHYDojGGPqJg0EAsrZw+1CMtTt7H8C1Wnovhp27Gti6xyDH0znV10od20i9f0SJfzQT7/FyoYFcrbEtKl0oaYEmtx3a2rjzT9c/uNZroIGn5G3vu6D4dFvoFXfIOiufOkq+Il4JRb/7vk55+nr/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AB6d9LRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AB6d9LRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F28C4CECF;
	Tue,  3 Dec 2024 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239439;
	bh=wfIOiBmG+EyBddZHyDJUKkHC/SxxwZ7Y6U+1NJQ9A6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AB6d9LRz5neY8gdKI2dPtvagaovp5OEbv6S7UG+V6DpA07rigfODd+/ECtwubFY/I
	 av5vBoitZrN6p0MtSmA+Sttt/6orWzxrlVTafaB1sdohCqa5uaiqE8WAE2qR1ZoAD2
	 CE84Hh/H5m5m8X2u63AmuIKru4MtvkVvnbHv4QYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 583/817] spi: atmel-quadspi: Fix register name in verbose logging function
Date: Tue,  3 Dec 2024 15:42:35 +0100
Message-ID: <20241203144018.677798022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9ea91432c11d8..e583146bf8504 100644
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



