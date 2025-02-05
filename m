Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C42B18E368;
	Wed,  5 Feb 2025 15:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767836; cv=none; b=Xbukc5GR+GDYhCM0fO+11Ga33S+fOD/bkZEMsMGiYhO8dicDPP8LVcxFa8t69e1TWJxFLxk79nsRfH5vRcirgDoQSZFVlj0FRbinNGK5V98cMNVbL30zjMyW7Ac/Xrf5j7NnygFj+EzaT7gg4f4dozdhez2fF7XBEfdwyBBF50Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767836; c=relaxed/simple;
	bh=8dk0DNbLq07hgDL2MHLA4RhNurvyFVwVwCOA0mDieD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0f+k8mkhrA5AVJmec2GEIxLcxYRzNOLIPjm0Fg7bJ8FmvzidJJgOD2tiuhyab53B0phhIJzVlzX/WJp2Qg+sH+R3RJDLVPIuhBuSR0a8QbEpMTGwVGcU96+aolO7rOC8zIvTcufQamv11fz3UJqixg/vyKSe+xtq3zcDDDdzfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fr2LwDIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fr2LwDIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8B1C4CED6;
	Wed,  5 Feb 2025 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767836;
	bh=8dk0DNbLq07hgDL2MHLA4RhNurvyFVwVwCOA0mDieD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fr2LwDILnTVYaDxwCoynwykfBk2jIxDlZ6dj4EZrgrc6JSye0e5TvGlE8JwZqRsK6
	 n0BBlahLa20i5z6fwQS+RwHKHNEvIT0YEOhboif6usytHRKyn16ucPsuMaSASYkY8k
	 WDo9n20VVTOAqdTd+9rSSfkp8uuAHJHWy4pdkfbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Desnes Nunes <desnesn@redhat.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 460/623] media: dvb-usb-v2: af9035: fix ISO C90 compilation error on af9035_i2c_master_xfer
Date: Wed,  5 Feb 2025 14:43:22 +0100
Message-ID: <20250205134513.812268914@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Desnes Nunes <desnesn@redhat.com>

[ Upstream commit c36b9ad1a8add3c114e25fe167efa217a813b0c7 ]

This fixes a 'ISO C90 forbids mixed declarations and code' compilation
error on af9035_i2c_master_xfer, which is caused by the sanity check added
on user controlled msg[i], before declaring the demodulator register.

Fixes: 7bf744f2de0a ("media: dvb-usb-v2: af9035: Fix null-ptr-deref in af9035_i2c_master_xfer")
Signed-off-by: Desnes Nunes <desnesn@redhat.com>
Link: https://lore.kernel.org/r/20240919172755.196907-1-desnesn@redhat.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 0d2c42819d390..218f712f56b17 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -322,13 +322,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
 			   (msg[0].addr == state->af9033_i2c_addr[1])) {
+			/* demod access via firmware interface */
+			u32 reg;
+
 			if (msg[0].len < 3 || msg[1].len < 1) {
 				ret = -EOPNOTSUPP;
 				goto unlock;
 			}
-			/* demod access via firmware interface */
-			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
-					msg[0].buf[2];
+
+			reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
+				msg[0].buf[2];
 
 			if (msg[0].addr == state->af9033_i2c_addr[1])
 				reg |= 0x100000;
@@ -385,13 +388,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
 			   (msg[0].addr == state->af9033_i2c_addr[1])) {
+			/* demod access via firmware interface */
+			u32 reg;
+
 			if (msg[0].len < 3) {
 				ret = -EOPNOTSUPP;
 				goto unlock;
 			}
-			/* demod access via firmware interface */
-			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
-					msg[0].buf[2];
+
+			reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
+				msg[0].buf[2];
 
 			if (msg[0].addr == state->af9033_i2c_addr[1])
 				reg |= 0x100000;
-- 
2.39.5



