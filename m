Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830963;
	b=DRBrdTUBXNfZSSwI1w9eG6+QdDarYgI3+huFKxv0FWjV5YHV9BnzSk21kdFA87+CIM1X
	 uT9eS02nH4/YFnKK49oht8jiGG6NK3gLcVb+wJNzHUCilWAtUkr/WqfjKzj5CaFM4YfMl
	 PTmPMcC7nCPJkma5nC7StbiVq67q/LU32+3iY7TMoUP5vycUp8CshgLol3UtvojTLSeh0
	 /lWVPYcQ1ZOFPPVuMLoIUQ2zvztj7GxgQhCRF7SpcNCsen0kQWfz2PtmvtQXTX/UN5y3f
	 lCQH4Ew6h+UTtM9Gfp/pEFho3nIQhEAY/eBK/X9gLoT1AYmVsvo7bX/aj1E1Owfci8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGsYs97f0WzLnymMYz+ECNgWR6/pZS3XWt3kd6Qrrak=;
	b=FOj8NQRtmcdOnTTjv3Bua2Xm1a8hFYUyyjomUijCcDsJ4+0VAnKb0OjnsF5v2f7gqaR1
	 0IAMOdzD1/vs6T6FYgKzlb7IguxK4lOG3ONC+ITXmpRfhf6n0h17bpKdJs1A4mMdcHGvu
	 a9zq0IfXLACvz4Qpp9Kyciq0ElslKZiJ77NA1bpD2Fi4M/lVbBTYzHlkBLZjWBCzSK3y3
	 nTbiL0dmVFGPZNJzhMBUQKYMPSWbAGy6PHvCu01/UR/T11Fniu3BPUzWeKPuswo2dDBMG
	 jE2WQ6m+CCu4iZM9VrPpN77CsSjeWGG3qZPVsVWfTEhdzM3dnmyiEsGilqaq+L+StjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2CmdbQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E471C606A876;
	Wed,  4 Nov 2026 22:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2CmdbQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4AF1F00A02;
	Wed,  4 Nov 2026 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830962;
	bh=qGsYs97f0WzLnymMYz+ECNgWR6/pZS3XWt3kd6Qrrak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2CmdbQUqGdHOG82lwTZV+vUCg6PVcqs4pnJpN4YsgRE11q2ZuZYy0eZsInglu146
	 mwbWj3GSkbcsGWYkQwfMNj/3cpPIT4sw/ktPbiKfS0aQlbJK3L+hQZ4WMtvvvvsM5a
	 TXGhY7sZRZbPXF0QN4bmZE6uTdxPdOWHu2TU7wzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0388/1005] regulator: fan53555: Add support for FAN53555BUC23X type
Date: Wed,  4 Nov 2026 16:02:01 -0500
Message-ID: <20261104211054.954556818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit e739acbe05b06de78ef7089470f122432f651faa ]

FAN53555BUC23X has the ID 0 and REV 0xc, starts at 600mV and
increments in 12.5mV steps.

Per the datasheet, the FAN53555BUC23X (23 option) is grouped with
the 00 and 13 options for soft-start timing (t_SS = 300us typ.),
so the existing enable_time = 400 is reused here as well.

This variant is found on the ASUS Tinker Edge R (RK3399Pro) as the
supply regulator for both vdd_gpu and vdd_cpu_b. Verified across
the full GPU OPP table with the userspace devfreq governor.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Link: https://patch.msgid.link/20260812125054.19111-1-arash.golgol@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index c282236959b18..59155cad99bc6 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -113,6 +113,7 @@ enum {
 enum {
 	FAN53555_CHIP_REV_00 = 0x3,
 	FAN53555_CHIP_REV_13 = 0xf,
+	FAN53555_CHIP_REV_23 = 0xc,
 };
 
 enum {
@@ -305,6 +306,11 @@ static int fan53555_voltages_setup_fairchild(struct fan53555_device_info *di)
 			di->vsel_step = 10000;
 			di->enable_time = 400;
 			break;
+		case FAN53555_CHIP_REV_23:
+			di->vsel_min = 600000;
+			di->vsel_step = 12500;
+			di->enable_time = 400;
+			break;
 		default:
 			dev_err(di->dev,
 				"Chip ID %d with rev %d not supported!\n",
-- 
2.53.0



