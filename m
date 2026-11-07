Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064801;
	b=p46LuIpcA9RkX/x0ZtQWQwUp4KPs0PRdC4AMbr36t9ozv+d3b0he6XI0rDSAkdZau/hr
	 XH2a2hcEgXADJg5uwSLLv6cQo6QgSi7XYBiflbO5FQ3Yk07P0wxHKJuffBORNExPq76X1
	 Sxe7j43rQ1P3781e12jeSYpuluGS7XJS04lkadM6M2hUNyUJDkEgGFiqFDIw3YXR4CH0t
	 3Kdd74QnNvEyqQoIPjrNbHYDJuHEyK9uDYSl8WjWFUPRJ34M0SuYqv7KckqdTot7Zl4NV
	 A0DMtqCXhTu2+Kq3+LiGmiSJP6WdpmA5az8PD6GRjB7SqxwGlfXTEdFV3jlRBCzFgJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DTWrzTmuT72UuiUkG5SWTaqpH2s6ypHympzFQgS8W4o=;
	b=ALBDDAtX8YzpC3NRgpuoX0YaHjXB0AoXtz4/L3IwKSRHr3KI4c6s7aOlXD5d837OpJoT
	 BD+CHFuHdryJmHcVMMblrBf1yyvPPoQPzY10u6g7jcMyjo1HQ2VZTrtD1T/MBsAz42sGA
	 oHxzWMN6+UXIXU/q/rtrAMJXh/jFMJha3+vnAPn2EpR7TPPmNVdoOPUFsooSj5ElE06xN
	 xXw/Zu/NGQtfUkpj7a+rm6EAWbZOfasMWzsi+4OMWJMbaJjFIj+NoVLC0s5Hq5sFrrssl
	 BNB5w4ccMmMS0BtmGajf44T0OiOMIjp0CoFXjKoCUhfrReQh+OOeE415c4wTfyC+y5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6gAQSxR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F1C606A33E;
	Sat,  7 Nov 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6gAQSxR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727A71F008A3;
	Sat,  7 Nov 2026 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064800;
	bh=DTWrzTmuT72UuiUkG5SWTaqpH2s6ypHympzFQgS8W4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6gAQSxRzm12bE1d3Hq1ylvJMTqUp4ZbEaI/bxNUMnEN9th6PRZilzZmOKMQI+rdT
	 Gi116OEhE6TnmojmMm7M5dNFjL2c2QgNGB/N8lv1zKdr9mvpmClbH5r/GSgL8s3rBB
	 fLzsB9a8XoEmBGErHlYfuYB/5jtWkelS3KmvOxuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Wenzel <g.wenzel@gmail.com>,
	Gergo Koteles <soyer@irl.hu>,
	Philipp Oster <philippdev5396@outlook.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0742/1257] ALSA: hda/tas2781: Skip invalid TAS2563 UEFI calibration data
Date: Sat,  7 Nov 2026 08:50:38 -0500
Message-ID: <20261107134959.782813402@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit a0f0325e92e505db6a6879d79da5aa88e94a36ab ]

Some Lenovo 14ARB7 laptops do not have proper calibration data.

Skip these zero calibration values and fall back to the calibration data
provided by the DSP firmware.

Tested-by: Georg Wenzel <g.wenzel@gmail.com>
Fixes: c3ca4458cc2f ("ALSA: hda/tas2781: add TAS2563 support for 14ARB7")
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Tested-by: Philipp Oster <philippdev5396@outlook.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/12a1ab265a1dc0e3a062a54287c8ef48682c4efc.1791895478.git.soyer@irl.hu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
index cff8fab8133a8..44855f593daf8 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -372,6 +372,11 @@ static int tas2563_save_calibration(struct tas2781_hda *h)
 					i, j, status);
 				return -EINVAL;
 			}
+			if (*(uint32_t *)&data[offset] == 0) {
+				dev_warn(p->dev,
+					 "Dev %d: Caldat[%d] is zero\n", i, j);
+				return -EINVAL;
+			}
 			bedata = cpu_to_be32(*(uint32_t *)&data[offset]);
 			memcpy(&data[offset], &bedata, sizeof(bedata));
 			offset += TAS2563_CAL_DATA_SIZE;
-- 
2.53.0



