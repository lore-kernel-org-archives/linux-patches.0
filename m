Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826982;
	b=RVuEuHtGdddoHwSVz24lAY2ouwdNfSSS76bWEmoUSNQ26YjBZtYVHX/JEa7tFCQn1hn2
	 qd7lrSujfZnPTZxZc42cYu/XtjQwFEp6pzS6SHeZ8Otmup6m9ae99aoBzWCUsrGVB1vIq
	 sx5V8o+OFvdWQ3iSSBEL8Hq811YJyHEk93VVnHhjnFB1/SZnbMo5KLFdSiuG4AmDGWOad
	 MDYrhr6NCTiSFpElfpjXue2i+avpL3xUcZ0xy1dwX42KeW/q9h3YA/IXKheeeUFg8Dk9H
	 PKI9DnxjdEgESz8DfAtG0lpuFK1/Nsoi9uk+SL0DeMkAkI+zBbEN4mpIIGNh6B6giFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tm4CMVzzYviwP51wFxzHyQavLL1uRFO7d+/d7PHVuCY=;
	b=c4Vow0OIyx/2bc4TVngpnagTRBrMHRViDBtNaCd1hFtIgL2OFxqCJAog+mLOwen95TcE
	 Wn0Ejbq8E07TOaAUc0jY3o1TBikxjVzyd/o/Scdm14zGBzA3M04p6ciYxGuhv5Fi+bBwE
	 4DUgjb/7aHvKwvu2RktQhr6eGwCahEjLy4AsQwNOhHwwyxVQTFauAtxSVj7peNsMMzeRW
	 GxbD6M1l2yrRS/CTC/EszyycKN8O7BazjdOivS2YG4vVVF0kAsjbzeb4b7L9+NxaHoH/n
	 oozVGbSuJzsyYUnYGMCoCVmglcmkMS1lS2iC+jqmDD2gpamZ8GtiILDrGZHRV4CGfhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeRNNwZM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF4F6073530;
	Wed,  4 Nov 2026 21:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeRNNwZM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E191F00A1C;
	Wed,  4 Nov 2026 21:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826982;
	bh=tm4CMVzzYviwP51wFxzHyQavLL1uRFO7d+/d7PHVuCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeRNNwZM77VFB1adM2pl2A04ywMfUkkt/5PeHkG6aTBw/iqikebyWmaPF6KhAlmXr
	 C8v/1WkcSdzRjGlm8UhSYCuynpfIxddRh4HYLtBw+dZMiq5P9HTzqS72nhLrQEc6Mk
	 5+7poTboEp7WSGKVhxJHj2qV9Jhsh8fp2srkg9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 096/547] irqchip/gic-v5: Fix standalone IRSes OF probe
Date: Wed,  4 Nov 2026 16:04:40 -0500
Message-ID: <20261104211040.954362435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 64212d63193cfd81849f5948365c7b0ecd011745 ]

An IRS is architecturally allowed to be standalone, namely, with no
direct CPUs connections. Make sure such configuration is allowed on
OF firmware by skipping "cpus" and "arm,iaffids" IRS node properties
parsing if they are not present so that the IRS configuration can
complete successfully.

Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Link: https://patch.msgid.link/20261015-gicv5-irs-no-cpus-v1-2-d4b337b7f000@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index 4486645a4b6f2..fb1cecef613b3 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -609,6 +609,10 @@ static int __init gicv5_irs_of_init_affinity(struct device_node *node,
 	u16 iaffid_mask = GENMASK(iaffid_bits - 1, 0);
 	int ret, i, ncpus, niaffids;
 
+	/* An IRS is architecturally allowed to have no cpus associated with it */
+	if (!of_property_present(node, "cpus") && !of_property_present(node, "arm,iaffids"))
+		return 0;
+
 	ncpus = of_count_phandle_with_args(node, "cpus", NULL);
 	if (ncpus < 0)
 		return -EINVAL;
-- 
2.53.0



