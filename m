Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034166;
	b=Ob2qFdJMCPIWLReDYcW3oryGL83ksTi8bfKreGzDtJM2RFDmqUdPbxKlRoGgjYjvW7w/
	 rQb231Qae845+rE4b2azkVCyi+0YoybTn0turFlNOowVWY6x22UjHD6KKHoqCQskhC/of
	 6SB06ok+PmyEKgvPNoc/fT34llLXmXYKb8FzqP05nMDe0dKa9hz8S1uBP5QFSpKBEMR8a
	 XIg1GuRbmF1wz/psROZuwvgn6I2gcvl3oLPY8YBMVFpQ9geuXukFTQSCEw/NC0mOWzs0Q
	 AKDxFyIkbV/yIXACF1UXTMOeja74l7Z3Hoq7oArbjxi3emiAI5PawYa6civDiOmLKQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k8nkzINpEGKqvu2g4jcbTJoWgRlw6ad2BntXTuxH72U=;
	b=X8OVob/Lhw0kdSw29EXItt+q3Cm4BnuwE0qsj9nzdlzPFwv3bGBmQb9BN9zcuuf3dR6d
	 nn5+qJSH3hU8C+rXFjsCTNBed+TKoe4dQZ2EgxzA1XDd0Jr/6Pc3D/i/k7Ivqazkzp+4d
	 GL6efOC1qYZXDAHN8/WjjexD4xWbkxfpXEUB5iuSo1NPvxN+2bO2ReXJZ8OZy6soLvX9u
	 XEYPca6B3hPkOEg/8VHQP1yiqSBdw2upgdM7apKXt7AMJ+s1PiqqQSbnlDtix+V/HayAM
	 tN39gn6GUJDtLNzUJK6QnVPgORxDhWLs6gIqNZDOuYwAd+9eFIWbBN1DFFnKs6mNBkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4cSIO0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D437606A337;
	Wed, 18 Nov 2026 20:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4cSIO0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B531F000C8;
	Wed, 18 Nov 2026 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034165;
	bh=k8nkzINpEGKqvu2g4jcbTJoWgRlw6ad2BntXTuxH72U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4cSIO0W/doPAk8KDa2jVEf+lICc2vJLT1C/F+9HzA3MYoYV6lk32ZAJq9+569Qwr
	 EUyUmvPZuiNLToz3F5H+n6NsKffVUnM9LiyNkRtiTXG22PTi/pI/TfUbte7qb55lHg
	 h8SUb84UHyGYTC0FJro2kTKMxNbygJYOYRo6kLkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0273/3318] regulator: fan53555: Add support for FAN53555BUC23X type
Date: Wed, 18 Nov 2026 15:14:55 +0100
Message-ID: <20261118150323.653608336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8912f5be72707..cabf0ad7d93b7 100644
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



