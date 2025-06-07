Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD65921E0A8;
	Sat,  7 Jun 2025 10:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290990; cv=none; b=R2fFej2KfBnNMm6SlkHjDF0/7I1szvw8zebMlfm2uH0wZXeFXmNjD8ThsljIjLGWrzfibvtBreWZgMlv2FLa69OoyogrmNezJe+yPOmrqEo60sVQQSUz4VEzql+r9kWmFFAwwjnNDXTHkWSTL9FHq60W6qD0x04xrXIVKF3jXEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290990; c=relaxed/simple;
	bh=IUweU+hs+4jIFllb31fYArpsMLua+Q52ixTUJBQVYJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hImyQJsMRG7UUUn4CQ7YXegjDr0or3+p26xo/6EHUeHT1rst9OxGOdcfgZcG9VaehVGOxvnGNRD5/ya8766ZfqyuYmtRg1dIBBidkCuAZYdp3pHDHg8PoEvV6IDN/z1DL0LrVrrryO1wQqgaffCT5hWnwW0b9LR0DnvBYbFCKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BI0lAJSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BI0lAJSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFB8C4CEED;
	Sat,  7 Jun 2025 10:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290989;
	bh=IUweU+hs+4jIFllb31fYArpsMLua+Q52ixTUJBQVYJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BI0lAJSXCHFfVPPaRf2kK2tOJv+YBL6S9sWBqkSDuXUOc8v3G7L1CmBdsFGwWeJPE
	 obgexggEfgcOYGLW3DtRoNO+/5HL43qGNVVdBqgmsUdGhO/TJNhKxVFQ4jwbECocW8
	 rRWHA/ECxdpx+cNuDWtjj5+WJlc1fmzb66ekfvYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Yeh <charlesyeh522@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.14 12/24] USB: serial: pl2303: add new chip PL2303GC-Q20 and PL2303GT-2AB
Date: Sat,  7 Jun 2025 12:07:52 +0200
Message-ID: <20250607100718.187014956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Yeh <charlesyeh522@gmail.com>

commit d3a889482bd5abf2bbdc1ec3d2d49575aa160c9c upstream.

Add new bcd (0x905) to support PL2303GT-2AB (TYPE_HXN).
Add new bcd (0x1005) to support PL2303GC-Q20 (TYPE_HXN).

Signed-off-by: Charles Yeh <charlesyeh522@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -458,6 +458,8 @@ static int pl2303_detect_type(struct usb
 		case 0x605:
 		case 0x700:	/* GR */
 		case 0x705:
+		case 0x905:	/* GT-2AB */
+		case 0x1005:	/* GC-Q20 */
 			return TYPE_HXN;
 		}
 		break;


