Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5243330BF71;
	Tue,  2 Sep 2025 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819705; cv=none; b=QYV2X/wqfcqh/N7ynGmctX7zBm9k4LNCcxFmCs8mHCDJ5Yd+lIiUNzWXWNd3XGncbKbKmElyKDN6vaVjiI9tR9f4aqaBkTnrEd2plSy38mxwtbUnDlOLX0LArjyV5NWtgQ1amqlWUocx8r6EvxtJDN+8enhqCehfHMe+7FMfzps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819705; c=relaxed/simple;
	bh=/kdzAlAFFGToW01prkm58NvEZKyF2AQG8Jt62Yf7HmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wiu18FIMvFJAKP+dSVk1Ou2Gcye0ivlJvO4Du3/bqwPszpazrP/sw5TfwOOLw7y61rYFZzj1TAla8c/IjGPl3u5+I8Uru1DDhwyEIk1UZY31R0LE1R/PEXuwV/xhb1mSwYK5+memT1zChr0hRiRGFCHnTzA1XvOBAgPCSuR0TBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL0I2mPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL0I2mPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61CFC4CEED;
	Tue,  2 Sep 2025 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819705;
	bh=/kdzAlAFFGToW01prkm58NvEZKyF2AQG8Jt62Yf7HmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jL0I2mPdrAizfGqDJKyA3e8pYCV7L5Y/+ItQtGIpqfsd4yTZbRy8mJd7dZx3yVX5K
	 1r3m9CBq8TDUL1kCJyunDayC5YBrQFS9T1VAqsYsNATUmQlaM4MuAqgUre3/tJpXqA
	 9fZfU1tnjxSLwnQ+vCfBIsuVODhT9b/+zkg/A0eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 114/142] HID: wacom: Add a new Art Pen 2
Date: Tue,  2 Sep 2025 15:20:16 +0200
Message-ID: <20250902131952.644721796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <pinglinux@gmail.com>

commit 9fc51941d9e7793da969b2c66e6f8213c5b1237f upstream.

Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -684,6 +684,7 @@ static bool wacom_is_art_pen(int tool_id
 	case 0x885:	/* Intuos3 Marker Pen */
 	case 0x804:	/* Intuos4/5 13HD/24HD Marker Pen */
 	case 0x10804:	/* Intuos4/5 13HD/24HD Art Pen */
+	case 0x204:     /* Art Pen 2 */
 		is_art_pen = true;
 		break;
 	}


