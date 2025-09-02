Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAC528AB1E;
	Tue,  2 Sep 2025 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820584; cv=none; b=mDaQ78eOMwHceOiDNeioKl2a/IwbnVicVJq7K3H1AiCRxhrd88OB6pKUxbfw2elUAsrrCfnqu+sGuIDVTyg9lpsTlIaQv3zGqqNPO5DB6491+dRWpryHq8KM070LUD7PhskJ0v0FyC1mw0nPeDbVnkdIBB5eMMkFZZ4NqCZEOuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820584; c=relaxed/simple;
	bh=AorxlwadGKarMB9VHzSKSsFJdn4cbSTc525IDPIjWlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkdlUTklh7L6nk0+4ngXebokcCuCFl0E5UWa897mnBx1LetT06BSMs+oWM7JisHUBIivxdbT1Yoj5coGZ6a3+iLf2gnZLC9KTBwHAoMR6v+wV+HZWtPpH3Z3pgyc24jVS1yQo9o4WjGIDhLjOJeCvCD34hSy+9vBMXO6DCsBR1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMEpC6Ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMEpC6Ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF6FC4CEED;
	Tue,  2 Sep 2025 13:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820582;
	bh=AorxlwadGKarMB9VHzSKSsFJdn4cbSTc525IDPIjWlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMEpC6Ct4Czo3ovm47jgUdGa3P6LpEv/2/xG2+o1En8SAJWeYo2T+OsW1O/OCLqBF
	 /v6yjWdWP/nd/5q6EreElZC7cOjFH2ZEP0O1SKXgDKyF6wbrx2nrxQXvJHFt2R6vkk
	 Ed/ia/za1iJiCHaV0pAfe60bmkxdj624TegcWGXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 24/33] HID: wacom: Add a new Art Pen 2
Date: Tue,  2 Sep 2025 15:21:42 +0200
Message-ID: <20250902131928.005521236@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


