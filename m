Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843473EF0A2;
	Tue, 31 Mar 2026 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976251; cv=none; b=VI6Zxv7Lx0yhy8woex15IkqAmshNwJH773qy9XTAe3dxuZrvL7o9xY8lK4XZEghQe0az/BPYNV4bhpQj+qV5CPRoorbLHaPEuPijAwESMu2wg/8maSlaPsCWMdg3v3qQYVPQstXtgQN0ZQaJvyafsO30+9lzbmgSZPOewWoaZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976251; c=relaxed/simple;
	bh=0Rq6myAIQC8Ady6IecSqHsvYGsHwuaj+cwvnxm0pKi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JloCymbcwi8Hyp+uE7hDDQvmKt1CKV+UscLsVrC1As9lGmehfJi71sVX/CZJ6Wt4FtycSj1Pm2rQ5TL/61OtzV/Dm+7jilwmjiwPUEOjVH2uN2nMA4uDos9juSJv44qH1dhru7NThq+Zq9pG2WO8ggVzAN72JtncX/WuBMaxcqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KT7Fwnus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KT7Fwnus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD295C19423;
	Tue, 31 Mar 2026 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976251;
	bh=0Rq6myAIQC8Ady6IecSqHsvYGsHwuaj+cwvnxm0pKi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT7Fwnusa2RWVAa4nZF0/sUFtthEvdV4daH8F7hfJ2Dihilb9thjHiH/6Ta0Cmo2f
	 EAF7PX1GNte3rMv8CDvBxaqzyjjZp8PXfZtqYns5JRXYF9NjLrRhpGfaW6WD9ShrbS
	 lC1jSs00illJUgFYQDyNtBTWynLvbvx5kjUOl6ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Metz <peter.metz@unarin.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/309] platform/x86: intel-hid: Add Dell 14 Plus 2-in-1 to dmi_vgbs_allow_list
Date: Tue, 31 Mar 2026 18:18:43 +0200
Message-ID: <20260331161754.222939105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Metz <peter.metz@unarin.com>

[ Upstream commit 6b3fa0615cd8432148581de62a52f83847af3d70 ]

The Dell 14 Plus 2-in-1 (model DB04250) requires the VGBS allow list
entry to correctly enable the tablet mode switch. Without this, the
chassis state is not reported, and the hinge rotation only emits
unknown scancodes.

Verified on Dell 14 Plus 2-in-1 DB04250.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221090
Signed-off-by: Peter Metz <peter.metz@unarin.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260213044627.203638-1-peter.metz@unarin.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 560cc063198e1..5b475a09645a3 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -189,6 +189,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 12 Tablet RA02260"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell 14 Plus 2-in-1 DB04250"),
+		},
+	},
 	{ }
 };
 
-- 
2.51.0



