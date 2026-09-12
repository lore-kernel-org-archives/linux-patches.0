Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BB5246BCD;
	Sat, 12 Sep 2026 09:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205788; cv=none; b=ZkgAbU5GmLsHFqJ4JwZ5bJzfcbXx3+b7w2y2rFafgn3qHMzGnXx1T7LxQG3UczMNOm+Mto6PpEdRUCwGwYp3qZQ3/FJRMUZ4wWQAwSnNeH8+e7vzY0WmcT3ERCmFHzxFFp7G8SmfElGZ+gqRvtCDHEY8x00yq3+LUYB8fA3ctqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205788; c=relaxed/simple;
	bh=aLZBl7UtCGlf8CEdWdYz4mfSWzmVQZ4TE9dgJpr7y1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2PeA7f5FDokAYOL7khyEQxuWrQCvS68/d84/gMl8sPUbb1E4cYSsi0YdkTtYGi7GyNtcgYTwYkgRHpUneRERaJ3CFTnCUybk07B+99LaDZc8k2wPXjgPY0gnZE3QfwSZAN4QSVLsMlJY1XqUaTYF+5fWj4fS295iDJv4qJMesk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuXh67BH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuXh67BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6B91F000FF;
	Sat, 12 Sep 2026 09:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205786;
	bh=97Z3uE6uwX/ovUylWsE+DePqQMCmjiuw3dQinfR8gWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuXh67BHz91DX5p+wD4GfZLOS/uArlIpk6IH6TfVJZn3aDfKYNWlDKA1Qk85VRp2/
	 Ms6F9M71kod1s8vWeZd3cpBggDu0DmkuJ9HtXeLuOAKtxwPMHU5BAYmKMfHQDP/+UT
	 9vfVGSP4hhUM33iwoOFB0Wjfg/3Q63mac2LX7smc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yahia Ahmed <yahmedd043@gmail.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0073/1518] platform/x86: hp-wmi: Add support for OMEN MAX 16-ak0xxx (8DD6)
Date: Sat, 12 Sep 2026 08:37:22 +0200
Message-ID: <20260912065625.111502156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit a7320d6eb9c4240c948cd9c64582b3bd04cbaf4b ]

The HP OMEN MAX 16-ak0xxx (board ID: 8DD6) has the same WMI interface
as other Victus S boards, but requires quirks for correctly switching
thermal profile.

After testing we know that (similar to another HP Omen Max 16 device,
board ID 8D87), the embedded controller on this board does not expose
thermal profile which means we have to intentionally disable EC readback.

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_no_ec_thermal_params.

Testing on board 8DD6 confirmed that platform profile is registered
successfully and fan RPMs are readable and controllable.

Tested-by: Yahia Ahmed <yahmedd043@gmail.com>
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260623141314.33947-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ adapted the board entry to the older victus_s_thermal_profile_boards table using omen_v1_thermal_params. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -194,6 +194,10 @@ static const struct dmi_system_id victus
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8D41") },
 		.driver_data = (void *)&victus_s_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8DD6") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{},
 };
 


