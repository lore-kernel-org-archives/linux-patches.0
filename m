Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82212450E2;
	Tue, 23 Jan 2024 00:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968276; cv=none; b=EZMmU27NN2/WzuA2FS1FCwdMKwgiIzeguXZvT+h9u7dOYezw00XmWaZTeaLkOIIFupbzNIhLj9e/88qJbBRfUJAgmruacFZEJx+sG8+qGHQLUPl8tlELUSXg0zzAe9oZdFRGcx6fqR+DjpbPpVPspn44iPvRqx5BHFjj8B71BxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968276; c=relaxed/simple;
	bh=2lRFw8oM1Oq1OuxlozaAZMLdzeMuqZP6nqUkcpqBYek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMaXpioEAQt5r4rtyrfSEMMZXey26cf+GWJXC0OMeBKafZ0yT7xQxZY0RFZ/2Xzrx/oIg1RNOeFtnbCU33ZgZ1/ZVqTIQTs2yGRbzkMcPicGmISEhEnrTcFHckA0JR5LVgZP4jnt6VGDPt6isgmnVYxHIN6x78uMoWuY47IsJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJGdXQcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJGdXQcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BDCC433C7;
	Tue, 23 Jan 2024 00:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968276;
	bh=2lRFw8oM1Oq1OuxlozaAZMLdzeMuqZP6nqUkcpqBYek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJGdXQcIWqyc9r2U2mKI+bB6mIkexMB+v3hsQPgu1TL+b/mx7jWuVbH1Xm5CBJ4ry
	 dUGsLvCCYM9+uwr9r/An5DGgXeh6y7TmDTa5kxB4DrBHoGpmE2c6szTZOqU5xEGLaG
	 xWNGpNrJCgFLoW6jWS8F/B5jqEHLW2pExmjPut3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhaskar Chowdhury <unixbhaskar@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/148] ncsi: internal.h: Fix a spello
Date: Mon, 22 Jan 2024 15:57:03 -0800
Message-ID: <20240122235715.099656247@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

[ Upstream commit 195a8ec4033b4124f6864892e71dcef24ba74a5a ]

s/Firware/Firmware/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3084b58bfd0b ("net/ncsi: Fix netlink major/minor version numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 8055e3965cef..176d19df85b3 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -71,7 +71,7 @@ enum {
 struct ncsi_channel_version {
 	u32 version;		/* Supported BCD encoded NCSI version */
 	u32 alpha2;		/* Supported BCD encoded NCSI version */
-	u8  fw_name[12];	/* Firware name string                */
+	u8  fw_name[12];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
 	u32 mf_id;		/* Manufacture ID                     */
-- 
2.43.0



