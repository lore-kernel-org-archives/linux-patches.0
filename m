Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4826417DA39;
	Wed,  3 Jul 2024 11:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005461; cv=none; b=MdLzCUPBWXnwR3zFv4gdrz09pDKE9ZPxnMhW4dtx+8/N2ND5NrpQWcCzkchDsd9p3/RxyhvRDe2A/whmiDaxFflEEOYQVUxlGEenoDnfROYunVU+/X+07yPS+uMt7dFnRak96/S89xJLOtk6miPBfH/oPWXGYn8OZ2PT8O+WcRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005461; c=relaxed/simple;
	bh=cB1L/VNbPEzpHSt0lfqjzXVe+3ZJwqshXREo/p8TJoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TExTtjPzHe/dHnrCL08+P+gTupLGViIpS44Ugq81mUXJPT7Ks9EdG4rQV+bBihG9A8F3c/qiOHvn7/Y+uWgfZfylu786GnH1avr6f1YFdgIBl0x9VQVRx9Yjrb/LbByekG+MIx+iJPnCSYW5u0FByAHHgDMTJ8kMH9Sm9EnAOTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlfAHHNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlfAHHNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BE0C4AF0B;
	Wed,  3 Jul 2024 11:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005460;
	bh=cB1L/VNbPEzpHSt0lfqjzXVe+3ZJwqshXREo/p8TJoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlfAHHNc+IyUfS4zZIcDoCMvj3Uy6uFX/b2aDO1H3JOCdeqrzE7k7BRAnrFASpq/T
	 02yQl+wr9JUjo+N3Fa7Ym76/fZsVBi+a2ZrJuG3LOcx6WmOSRk+yPCl8BIw2EWvNMf
	 5EgbucQ/oCGfaefFqCQFFdV9wqR43etje/J6H634=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/356] gpio: tqmx86: fix typo in Kconfig label
Date: Wed,  3 Jul 2024 12:37:05 +0200
Message-ID: <20240703102916.468953293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregor Herburger <gregor.herburger@tq-group.com>

[ Upstream commit 8c219e52ca4d9a67cd6a7074e91bf29b55edc075 ]

Fix description for GPIO_TQMX86 from QTMX86 to TQMx86.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Signed-off-by: Gregor Herburger <gregor.herburger@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/e0e38c9944ad6d281d9a662a45d289b88edc808e.1717063994.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7b9def6b10047..a36afb47a6334 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1396,7 +1396,7 @@ config GPIO_TPS68470
 	  drivers are loaded.
 
 config GPIO_TQMX86
-	tristate "TQ-Systems QTMX86 GPIO"
+	tristate "TQ-Systems TQMx86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
 	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
-- 
2.43.0



