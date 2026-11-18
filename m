Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059489;
	b=3ztb1PDNk29CXHBNp1Wz2Kr3manA6SRWbaUWYPIPR7RNbfnwKQWfJ6+qvrUnKIyz6GLn
	 pnWnh8gRJ5anQaIiIFWMHfHqzizYg+9Gs2nk2UXIfzyUx3R7hmD0vvrtYJfAt/frll/+4
	 JDoosSMkBh82MpjnS0f9sDDYIA2RFFxAqws5ovUhrsl8LcETgFl3qJtH/7F+z/AJ4Ym42
	 YZ9Rn/YreiOj6MeFYdk911O7a2mZljvEEc/f0GheUbiaDclffSasaWfAHiprGMzH3p3Eb
	 XcQaeyhtpkOKGsgY1Tul3F94Sa4rHG3MlDyLc4Lino+9D5StMkQ8CF/omHDuO+qQI6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gZaQdMhNEJ6+B5SEDFkrNCcjD19Oiwnv1KwxMJvmdHE=;
	b=nCyNy5fcVHffNcr+foU5ihlOjCleCTu46JXIfP5CrKIEg9SPbyCQDBl0j206T00nM2vE
	 Yd6qzjx2MF9cQfGQbZkvf0drJr7lnupQCDAfLcZgZKcsuvxx3GlnPxABcViGn/M+u4cUm
	 3pdPELSGo1kd3FY17gyLorzgJ4mBlYZBG8n7TTJaeRt04mTsUtc+hsEcf3T8tEFhv1dIW
	 Cizo0XGiZfPKdsIhPL1G3opGguoubT+Yzf3+AoK64liQSR8AAoxOcdcahqMSp1PhKUjNs
	 V49nzHK7em4LiEnSIv0k0tk6ofWX5LAjdjW9xu5oVi4/r0n95uPAfyjNw8Xz16Nvqgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DC4A34Gw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8D3606A325;
	Thu, 19 Nov 2026 03:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DC4A34Gw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B221F000C4;
	Thu, 19 Nov 2026 03:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059489;
	bh=gZaQdMhNEJ6+B5SEDFkrNCcjD19Oiwnv1KwxMJvmdHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC4A34GwfHFQqc5v3Pf1ZkGhSx0wfgA/MtkH6Eew+Vz37+kcZlL4/sA6v0Vegg/PI
	 luv1a0S1Cen7ySBYYlSEKq2JBf7e0JyA3ymjgp3xBSku+1dUWNA/rBk+4LNJ18tZUP
	 0vAcAGYx5Rz+PS0pE59i16i8WdIoHTxFYzqQGLZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elia Devito <eliadevito@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0843/1848] platform/x86: hp-wmi: rename "thermal policy" to "thermal profile"
Date: Wed, 18 Nov 2026 15:48:01 +0100
Message-ID: <20261118145951.912711743@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elia Devito <eliadevito@gmail.com>

[ Upstream commit d7da7534272f7b42629042a5b6fa51debca9201e ]

rename "thermal policy" with the more appropriate term "thermal profile"

Signed-off-by: Elia Devito <eliadevito@gmail.com>
Link: https://lore.kernel.org/r/20210221210256.68198-1-eliadevito@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 6dea092b261f ("platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 6642d09b17b55..370f74fa4a9ab 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -87,7 +87,7 @@ enum hp_wmi_commandtype {
 	HPWMI_FEATURE2_QUERY		= 0x0d,
 	HPWMI_WIRELESS2_QUERY		= 0x1b,
 	HPWMI_POSTCODEERROR_QUERY	= 0x2a,
-	HPWMI_THERMAL_POLICY_QUERY	= 0x4c,
+	HPWMI_THERMAL_PROFILE_QUERY	= 0x4c,
 };
 
 enum hp_wmi_command {
@@ -875,19 +875,19 @@ static int __init hp_wmi_rfkill2_setup(struct platform_device *device)
 	return err;
 }
 
-static int thermal_policy_setup(struct platform_device *device)
+static int thermal_profile_setup(struct platform_device *device)
 {
 	int err, tp;
 
-	tp = hp_wmi_read_int(HPWMI_THERMAL_POLICY_QUERY);
+	tp = hp_wmi_read_int(HPWMI_THERMAL_PROFILE_QUERY);
 	if (tp < 0)
 		return tp;
 
 	/*
-	 * call thermal policy write command to ensure that the firmware correctly
+	 * call thermal profile write command to ensure that the firmware correctly
 	 * sets the OEM variables for the DPTF
 	 */
-	err = hp_wmi_perform_query(HPWMI_THERMAL_POLICY_QUERY, HPWMI_WRITE, &tp,
+	err = hp_wmi_perform_query(HPWMI_THERMAL_PROFILE_QUERY, HPWMI_WRITE, &tp,
 							   sizeof(tp), 0);
 	if (err)
 		return err;
@@ -914,7 +914,7 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 			hp_wmi_rfkill2_setup(device);
 	}
 
-	thermal_policy_setup(device);
+	thermal_profile_setup(device);
 
 	return 0;
 }
-- 
2.53.0



