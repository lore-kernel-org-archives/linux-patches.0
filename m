Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3C21EBA12;
	Wed,  6 Nov 2024 12:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897103; cv=none; b=O03TMjC+a6m0XsbBBbJvf62qJGOG0Ga2ze9EmBtC+ANqlxV+3Y3jhdZ88rGV6kw8DGJaaAQvLPtyWJ/DusFtMXF6T0nk7R2QrydNB1uX7D5/VtlCVyuA/22jnsIuAJmp00cuccKVaHAJbEhoPDFfotWI1982Q62xNQcwGo9wPjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897103; c=relaxed/simple;
	bh=D6XkY6vWJwhcPwcyJ/ihBpuNIxW1MKh59w3ZkV2igrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4WtLGg9YXueCH66LyBsMrQZAqkD3LrQPpL9msAC93hSwFsQpvd7Bzny5DJV+FOStN5MW8t+7Pum3j0h5toWtWswievMb7y754dYqruoUq13bFKoQlo2wONKzOP4wDibuzXsfu76ChezJxYgncc6524jCk/holQwkDIq4fGZYlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J67RQh0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J67RQh0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F49C4CECD;
	Wed,  6 Nov 2024 12:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897103;
	bh=D6XkY6vWJwhcPwcyJ/ihBpuNIxW1MKh59w3ZkV2igrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J67RQh0IJKgI6I6qb1L9VhLBxeiZ3NMxShMW4DBDP1Se17qZneQcc9HwWzVLgbe1A
	 QXCzR1Q8JWFgrb4bhAHMiaDH6LFFky239VP8pYch8ZOqSGSRC6PTj49FkWujOIyV7+
	 9Xw1qxsNQ5y4oghgRNPud4NweEcttPaAm2sdo9oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongren Zheng <i@zenithal.me>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>
Subject: [PATCH 6.1 066/126] usbip: tools: Fix detach_port() invalid port error path
Date: Wed,  6 Nov 2024 13:04:27 +0100
Message-ID: <20241106120307.872900728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


