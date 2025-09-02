Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85415307AE6;
	Tue,  2 Sep 2025 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820520; cv=none; b=AgAdn0JQa5U2solXdAr0pT1jl96N2ySO2i8byrzkX4r5LL6kLeBQ7z+yxbVBwPlIcpRLNVu+af22PcfzU48g9ALZudX1CTyHaMU4vWZJjd3CmNwtoIrNczlSvY4CNuhqjNMXMB45CxnY55Gt5vXiXmXJAgWdq+e3a289OvSXsxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820520; c=relaxed/simple;
	bh=o+Tc/DqD1fdAcGjnMC8VbHl82j+kAeREyOrSieJD1xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqTd888DbwwHHmg3/GS03l5tnz9O15Oy1XeFUautj7QXpAITC6DADcsKFmDRhvLl9dlmV55fK/1gcPaEGl5y3/a6gn+49tSZmHWtwnWjV9J7eP68Rrqu8hTXTL7shp9j/nz1O3QB6H8Caia6lGhhpYNZe1ISrcZV76WVQKnQgGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5ZJcwDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5ZJcwDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7D0C4CEF4;
	Tue,  2 Sep 2025 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820520;
	bh=o+Tc/DqD1fdAcGjnMC8VbHl82j+kAeREyOrSieJD1xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5ZJcwDHeaLbB94UqHwTOCKGBp9nFvPqSR1bRa5SvNq1ook/4E685gRl2ZfI9ybe4
	 KhmsbpraXBLebyvwJjla+uKBstlS3YABPgigG+iZeJM/N4yA21dwY+baEWCajevp2J
	 rYWJxxUAvFVCmOnpcW4n9rPmElHirzdp+WLxUroc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 38/50] HID: wacom: Add a new Art Pen 2
Date: Tue,  2 Sep 2025 15:21:29 +0200
Message-ID: <20250902131932.035714939@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -679,6 +679,7 @@ static bool wacom_is_art_pen(int tool_id
 	case 0x885:	/* Intuos3 Marker Pen */
 	case 0x804:	/* Intuos4/5 13HD/24HD Marker Pen */
 	case 0x10804:	/* Intuos4/5 13HD/24HD Art Pen */
+	case 0x204:     /* Art Pen 2 */
 		is_art_pen = true;
 		break;
 	}


