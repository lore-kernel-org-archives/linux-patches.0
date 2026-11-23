Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422841;
	b=Vh5RBjXisr1+voh5ZkDXzFReTnJk14k/nQcwhSNtebj71dWImF334hex2A4SGf2NiRLd
	 BxrUSl62TVMFZ9KmZyC4mko1sxlF220ZdWqV+ERtE9AFboPsfzvKe6SjKpHGSRGxG7l7F
	 BKlBZzR9lECmZEHhydIOvVc6FBcMGpIJ1K636zOL0rEA3mTaDCP/asY4JNTKUWiWxfcNB
	 k1F/8eZeEepGHsa3g4k6/0I+NxCEj8duqraBhpeP2dk9Gw3tIbYAftbFKh+MGHjZrIPc6
	 GYpxER3738j94ipMNpPyKjLsfPFpw8bJ+FcoV2OKaDUc6MmfFQGiwBZKFh8dNiNe7tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wFon/UVHGemT3WTMnjxrH3fsKcc72DMvpEVzA2fPmSU=;
	b=OKfy7HuJGbVavSuY1pCYslm032Gmn2PhbzXsLN3Y+NkEECCzkLmN2a/ivUMe/oAOnXMA
	 dXSF7eTzPGTA8GVaEtxB6FIFVJMEf7tF2PVjDFiJ2ypvcctAfYC+7rlToqHXEN0srFyIv
	 tdrIxrN6RJim5zPr9rGtwqVlimX1G9Rh64w2tL81IKA+pMT8hEK/QhodvHsH02oGx63e0
	 JZisT4GeMyPUCxfdZFLhh6UOVY1YiEDXReogTA1IpgA6FpHlKbt+yS9fe+OxbkGOyd/qt
	 RVYQJFYCh96mQLTC4igRhKtcxUs+wAk3WE7Ma+c/YFxzflgaTyVO1SnErv3OBppmBZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jn1MVQyr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A50606A31E;
	Mon, 23 Nov 2026 08:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jn1MVQyr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DC61F000C6;
	Mon, 23 Nov 2026 08:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422839;
	bh=wFon/UVHGemT3WTMnjxrH3fsKcc72DMvpEVzA2fPmSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jn1MVQyrOh9v9TOZK385nBTL8pZ7v3+LLTorgr0+Oh4QWUOTIuDKb33z9nZ47t5pY
	 kLx7g8rB5oIPwRiV4c855iLHeJgM13pEyV7SxPE4E6K/6HAaN2uCEIlCzOmL7k9cDc
	 aQAHma7vLYQ3W03JZ3tt4wY4+GuZGaRSZLNJO0Lt69I2wQjAcgb/R/bjrKuurSFo4Q
	 ZfVp7Xy+wGrm975mqzpEN6oArZ7NWAuRR2bKIlOA1sHtrzv3MiZviLw/m2WqlF2YdG
	 cwNjplW4hdZ/VUzru78jCxrjsVNmruHq0djfH1ETh/QyZZRnKTpHN+K4aoKKjat115
	 /feisdVAqkPQg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v1 02/10] coco: tsm: Register the TSM class before device drivers
Date: Mon, 23 Nov 2026 14:03:29 +0530
Message-ID: <20261123083337.2731019-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
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

Register the built-in TSM class with subsys_initcall() so it exists
before a platform TSM driver probes, independently of object link order.
CONFIG_TSM is boolean; remove the unused module exit path.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/tsm-core.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index f07e68dcf6e1..31ef48203eac 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -379,14 +379,7 @@ static int __init tsm_init(void)
 {
 	return class_register(&tsm_class);
 }
-module_init(tsm_init)
-
-static void __exit tsm_exit(void)
-{
-	class_unregister(&tsm_class);
-	xa_destroy(&tsm_ide_streams);
-}
-module_exit(tsm_exit)
+subsys_initcall(tsm_init)
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TEE Security Manager Class Device");
-- 
2.43.0

