Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4865A2528EC;
	Tue, 29 Apr 2025 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948037; cv=none; b=fjCIv8thDN928GZqWIXy9ICmWe+pwvStOtWZdnLF6IIthCNklZGTq/0POPzYEQH+Ru5E7gdH/SNNI3d4XpfAPe0ynHi7hqcf6JiD8EqZTWA7uLGiTwRmQGT/SfigqODmpr4/8REVzsxocy+7L5uczZe5Qd6irz0eVEfyoa5sMV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948037; c=relaxed/simple;
	bh=Cj0FqzQxBDUTY6UU0DBWgU+esLD7O4VquqjKzX7eqns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lV+UqtuxiUmo4uDGIbTIkA48b2CFmNxLEnofXqQrPnVuRo1q82MRSpV/mYp4w5zOcl5ZER2TrjDl15W0ZYUncvnS1rSSwjRzbL4kSEXiK0HhB+mmE9SEA1z7F/A+m7FX4VcCO1+m085u6CdhWDwreyktFFNqBXGhOXwIZ0J+AzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlRFy/x3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlRFy/x3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F6CC4CEEE;
	Tue, 29 Apr 2025 17:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948037;
	bh=Cj0FqzQxBDUTY6UU0DBWgU+esLD7O4VquqjKzX7eqns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlRFy/x3gZg7aUnxsw5bcq73iwt7kmKMhRQo71XXK130m8A/MPLTBK3iv9G0/mNAc
	 25kntWaZpB/dcRyevLLBRW2PzADSqXuTiRzfeKmQCnIYznLeHT01xZlFTXKGlkVVXf
	 L1wt+9HAqhvkXLoeyD1wmgHe4ihZPPCd9dtAjK/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Xue <zxue@semtech.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 134/280] USB: serial: option: add Sierra Wireless EM9291
Date: Tue, 29 Apr 2025 18:41:15 +0200
Message-ID: <20250429161120.612308136@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Xue <zxue@semtech.com>

commit 968e1cbb1f6293c3add9607f80b5ce3d29f57583 upstream.

Add Sierra Wireless EM9291.

Interface 0: MBIM control
          1: MBIM data
          3: AT port
          4: Diagnostic port

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1199 ProdID=90e3 Rev=00.06
S:  Manufacturer=Sierra Wireless, Incorporated
S:  Product=Sierra Wireless EM9291
S:  SerialNumber=xxxxxxxxxxxxxxxx
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=(none)
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Adam Xue <zxue@semtech.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -611,6 +611,7 @@ static void option_instat_callback(struc
 /* Sierra Wireless products */
 #define SIERRA_VENDOR_ID			0x1199
 #define SIERRA_PRODUCT_EM9191			0x90d3
+#define SIERRA_PRODUCT_EM9291			0x90e3
 
 /* UNISOC (Spreadtrum) products */
 #define UNISOC_VENDOR_ID			0x1782
@@ -2432,6 +2433,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9291, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9291, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, TOZED_PRODUCT_LT70C, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UNISOC_VENDOR_ID, LUAT_PRODUCT_AIR720U, 0xff, 0, 0) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x1bbb, 0x0530, 0xff),			/* TCL IK512 MBIM */


