Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256EE1D86E8;
	Wed,  6 Nov 2024 13:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899056; cv=none; b=FUquDZBpqYYdbMU+IHHYezMkA/wMKMXpA5w/goOajC4wp5Htm7S0VnjGEDATicpFzqqaD9NirxOCEqUGShizFV1uoX7S1OrXhtIFSdGCpnSAju2sFgsMASeG9VoO0OrfWXTPJY/AHLPxHFIFyY62+OME9u72mFMEb8qTxYcaaUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899056; c=relaxed/simple;
	bh=tYwvO7a4NSZvbZGVjgN85sE9uPCuoDS1AkGcYIoHlKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqwWp1OhBL1ZMGSXW1tDt+mw+2d2D0CoMTp+l+ArJ4OOykLG7VSSSAiqiv6yY9C1QbDrrlq2HxEOT8IPLWrUkaDhC7XbGTNeBTW4eK5oZePjrHjYtr5X5QMljTPEUyjyzT+bnyJ+7yc0pigTWoJqwRf8gwj632oRau59wJhUNkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXDh2503; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXDh2503"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24AAC4CED5;
	Wed,  6 Nov 2024 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899056;
	bh=tYwvO7a4NSZvbZGVjgN85sE9uPCuoDS1AkGcYIoHlKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXDh2503j4x755Ra/ttfpX0Hr00iXoH2Kjl1OGdDFMFJHEcgwWOVfjQdZibgJkIT4
	 NyDtJt8+eeukuEv8v1qw/DQcj/F0dr6ilLOklvRb1FJmr+PCvPqJ9G4A9iBQSeEsHL
	 9U9Onbpx+vi9ZjY7RFsH2GN6CFeC7bm8rXoZv5CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongren Zheng <i@zenithal.me>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>
Subject: [PATCH 5.4 446/462] usbip: tools: Fix detach_port() invalid port error path
Date: Wed,  6 Nov 2024 13:05:39 +0100
Message-ID: <20241106120342.517793064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

commit e7cd4b811c9e019f5acbce85699c622b30194c24 upstream.

The detach_port() doesn't return error
when detach is attempted on an invalid port.

Fixes: 40ecdeb1a187 ("usbip: usbip_detach: fix to check for invalid ports")
Cc: stable@vger.kernel.org
Reviewed-by: Hongren Zheng <i@zenithal.me>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://lore.kernel.org/r/20241024022700.1236660-1-min_halo@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/usb/usbip/src/usbip_detach.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/usb/usbip/src/usbip_detach.c
+++ b/tools/usb/usbip/src/usbip_detach.c
@@ -68,6 +68,7 @@ static int detach_port(char *port)
 	}
 
 	if (!found) {
+		ret = -1;
 		err("Invalid port %s > maxports %d",
 			port, vhci_driver->nports);
 		goto call_driver_close;


