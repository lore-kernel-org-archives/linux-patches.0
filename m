Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060941;
	b=deREDqqTFKG5Mpi+tLJCNYFLiXhGlNueXk8XKU3cSv2TqDB4HRoNZRsPDCkjrQtmF/+b
	 04SfMak6RZjbVIFH+X3eRFqd84PLu/xSxvRpI6bHSjJLKUu4ouAn/7W4grjgDyH01IN88
	 7zETAg5WJ27roFgPWegaWZaZN8DFfmlKUVWtWHw0/js6JPHon6IeSY/n/3UJkjJ5L0Gzj
	 oQobwY0AMrHMykGB3pjNNLPPVP5J4PFNMYlKzRM5te2OI57Fc3b35TklSBa48U9/B/hTX
	 MFJ39xLyhEs+qR6LpPwZ7gn3o6XmsyshtZMxoK7Y12ibMdBQXX+u2+JubyFle1WSnpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+fnxL5pEwUoALUfAujKUNNS9Z7E3shg9Y971CAUM5Fk=;
	b=2IIkpUxQ9JQX3GxTWE35sIJTorThjyxQRfTRHQoe9kv/Kfu36KEbT3nwuTxIZxuiHMYz
	 wH8F6hyYFqMhim7/E+HSdAJSbu8liYsSq81fUrCqMvScsQnKF5UOPC0uJaNNtlMVb05OE
	 ke4r8jJhF65Pa8MgRHbVcg2qC1RVB+Vme5WH6aKrGCGb4hWXKSc3hRD7yZcHqZhhpjsNl
	 kVH1M+MF3SXNTeC2ah0JodDTbIcep9M3sDaj8tV+xHl0PeUWTc2Rw1RLNUP5xKJMswRGS
	 OT2uuaLfgrdMS8R4qaXov+jg/DCuIi5CjN3gN9M08tetM/5tBcqgTLlNxWc1AmXZMUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlZkPzo7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839C2606A325;
	Thu, 19 Nov 2026 04:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlZkPzo7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F371F000C4;
	Thu, 19 Nov 2026 04:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060941;
	bh=+fnxL5pEwUoALUfAujKUNNS9Z7E3shg9Y971CAUM5Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlZkPzo72M2sjdn2rxUdizKu++ro8IBpfrj+Sf/j5XC4k6dOQe+IsgFxLJvPNXmSr
	 lC93OcuIzYoYgHfWQ+1nsi/xh+RzOYNdTONhhohfPFSwdNKGYmugWrFRJ2qcD9uxMF
	 zc9gSk8oPUdO1q3oQYzEhK+Upuhu3S+yvPZpWYaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1327/1848] mfd: intel_quark_i2c_gpio: Unregister resources in reversed order
Date: Wed, 18 Nov 2026 15:56:05 +0100
Message-ID: <20261118150015.315949239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1514ce4935f317384313af88c387341997665c78 ]

In ->remove() unregister resources in reversed order, i.e. MFD devices first
followed by I²C clock.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index 84ca7902e1df6..7ed697767b888 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -268,8 +268,8 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 
 static void intel_quark_mfd_remove(struct pci_dev *pdev)
 {
-	intel_quark_unregister_i2c_clk(&pdev->dev);
 	mfd_remove_devices(&pdev->dev);
+	intel_quark_unregister_i2c_clk(&pdev->dev);
 }
 
 static struct pci_driver intel_quark_mfd_driver = {
-- 
2.53.0



