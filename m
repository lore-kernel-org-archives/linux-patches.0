Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925C13BFE55;
	Thu, 15 Jan 2026 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498035; cv=none; b=skDkMs+iy0gr8bEc7xZ8t4HZRGcbNekAu2Awvo0beZGY5kk3m40NeDeGX8rpVhM9rCsr6yIxEGnEZj/+gHvOmD8v8DD3Roc37jB/oMgdvimYsMy6Fr5wiLiQ9+IUp2XktrVA6i0T3d3Z8c3nH8wQkto0t2mOvJmtAfGqAwvsiB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498035; c=relaxed/simple;
	bh=d+IjrKVQuF8L0pfkBKyBoqoYFyyOHLCWG0dH0E81Esk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciqkEq3ElhEqde4ZRxypIY1EjpnNPH0/URsj9AgkYzTHOgdtJJkmh4BOEJ7QIb0/EKCpjRVIWPPL+mU1a5KXig21ADyzCVuti4VLd/O4AXAA3ymtm91lO1UFmppQI415tv0U8yPQrcjA0zQ3mzDP9IBjCg+DAYr+wVM7dUk7fjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrSeJnok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrSeJnok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD2C116D0;
	Thu, 15 Jan 2026 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498035;
	bh=d+IjrKVQuF8L0pfkBKyBoqoYFyyOHLCWG0dH0E81Esk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrSeJnoklUDYbITO6NJUSVjR+wwfSzz5epJRLURv1f6vOz4YF+uYjx+WAzBYd6iM4
	 2zXNZaQffETDD+tSp/ehs9SNsF2bnKFQMsCl53kukIq9YdfJacBYM5bCHawPaZLvw/
	 O5nkbnoWnQlMN2ywst3mbCU7ui4FrLEwTSNIgbgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 291/554] media: pvrusb2: Fix incorrect variable used in trace message
Date: Thu, 15 Jan 2026 17:45:57 +0100
Message-ID: <20260115164256.759573685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

commit be440980eace19c035a0745fd6b6e42707bc4f49 upstream.

The pvr2_trace message is reporting an error about control read
transfers, however it is using the incorrect variable write_len
instead of read_lean. Fix this by using the correct variable
read_len.

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Cc: stable@vger.kernel.org
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3617,7 +3617,7 @@ static int pvr2_send_request_ex(struct p
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
 			"Attempted to execute %d byte control-read transfer (limit=%d)",
-			write_len,PVR2_CTL_BUFFSIZE);
+			read_len, PVR2_CTL_BUFFSIZE);
 		return -EINVAL;
 	}
 	if ((!write_len) && (!read_len)) {


