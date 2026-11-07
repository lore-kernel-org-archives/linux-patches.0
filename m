Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064251;
	b=FqVY80kJKLy2uHLVlqfIvoeA4dYgMg+sdNEUEVJNKDKSSL/TCb7w/82fGSmZnYyL/SKe
	 S50pNHEjVd3B8M8hVXlwmTVU+Sqsqwd/iaqvkkA1Oj9BFhAn10ET6l003OH5uYfdgPFC4
	 uPZQNL5xOfFj7qlFPBeaNT8LSCoi/XC5kz3/i2SLvLHzy6H9oqKuw0T9+ZgE0gDiOZjiH
	 fQx47KcxOSl3ep8UR4WOrS27Ca7e46gkzH86YideXaresF9ySy9F7IX44N9k7/US1r6Fo
	 Voj3JrpBPECSYRU4wxs1IQ1yamnFrlRYqdgQoOfKm/H1x5pGB7UQiQqAe0/Az7rZlVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZorMtKiaVZ8O9+yX3wZsI79N0+PGjEeATICB+6Bf43w=;
	b=kls7Ahrz7SKH11kaU11IdV7NQc3sFLuJZKr0a+kRUbroPqhAO+rlO6dYIFio16ImIoDC
	 icTz8LG/Xt8quuT52awnHCSQaSKSixVK+hRdyUba4mOmwpO1Gj4HgZnPBuXdDvciFaaDB
	 VJlA+JyDeSr16ltD3ZAjJ08Y46jiHnW81pCRu6NA19Ydb566LVMPFHmDS/3ZM5c2uwLxC
	 Gje1ehpZfQWIlZFqYUCO8P1y/LbZJRTHnTOjpLDKmOhtKijfjJPBLwsY1RHKDILlJT6Ah
	 BD363jDPWb6xIlZ/QoPcNK8aPOwfOmQcOA3OlhjZi5OkIABj0Bj30r8VllmtsNuTlNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I958wkme;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0D6606A9C6;
	Sat,  7 Nov 2026 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I958wkme
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662041F0089F;
	Sat,  7 Nov 2026 15:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064250;
	bh=ZorMtKiaVZ8O9+yX3wZsI79N0+PGjEeATICB+6Bf43w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I958wkmeZfHwGHT8mBXmjQmhNhP6K7ntBlIXE9MecTkLP6fzx45+suRyu21xmVuft
	 a8e5u7IJw2EcbVZvhgcrrqCGpRsHTUKsqpdiUk47kNSCZfOo9PSUivqlxTmTAGTgau
	 UDi+rvl4X+QoLCd0ZUWRFd5dt3LxbO6+cdB4vyKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Costa <2000.costalucas@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0353/1257] spi: bcm2835: fix device_node reference leak in bcm2835_spi_setup()
Date: Sat,  7 Nov 2026 08:44:09 -0500
Message-ID: <20261107134949.139723044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Lucas Costa <2000.costalucas@gmail.com>

[ Upstream commit 8db44cca03df066186d6220bfad9fa482d7cdc13 ]

of_find_compatible_node() returns a device_node with its reference count
incremented, but bcm2835_spi_setup() only uses the return value to test
for a matching node in the loop and never releases it.

Declare the node with a scope-based __free(device_node) cleanup so the
reference is dropped automatically when leaving the loop body, matching
the existing __free(kfree) usage in the same function.

Fixes: e19c1272c80a ("spi: bcm2835: Restore native CS probing when pinctrl-bcm2835 is absent")
Cc: stable@vger.kernel.org
Signed-off-by: Lucas Costa <2000.costalucas@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260925193008.127314-1-2000.costalucas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 8f8715809c7ce..23606967f7d1f 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1297,7 +1297,9 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(pinctrl_compats); i++) {
-		if (of_find_compatible_node(NULL, NULL, pinctrl_compats[i]))
+		struct device_node *np __free(device_node) =
+			of_find_compatible_node(NULL, NULL, pinctrl_compats[i]);
+		if (np)
 			break;
 	}
 
-- 
2.53.0



