Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8D535B129;
	Fri,  9 Jan 2026 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960519; cv=none; b=YsbdccE5qLT3BGrZ+P5UyMf735GkL04KkdRX88J9Eo3IUQLAeLoRcpuj0fZoVBAi0tP31q2XqaYmWdFNxF9XHBnBcm9KLG/kETdiKOEB0t6Y3a/RmpHickFpWVIpBUBSPG1t9Lp6RkDDlIEkJoQy/qibx17Lb26YBghnVWpuDBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960519; c=relaxed/simple;
	bh=B+RIXjEiVok8W2amvEdNaGA3yYvtacBkpbb7lgZghLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiUx4VdoNVIFHhjkPqhnzf1jHzzzwcTcwFKYBiLL8UFlbWkuCulcI1jBBSHdPwsyveT+vA/oG6ABq3aObKRL1quNqTZX413/1VLqwb02ygk7ED89EMu8IL7GKO1KBeYYN1lGWrJydZ6XhioJL0AdFVPAtU/f7RVZvRzutuFqJTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRXOt0TL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRXOt0TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EA6C19423;
	Fri,  9 Jan 2026 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960519;
	bh=B+RIXjEiVok8W2amvEdNaGA3yYvtacBkpbb7lgZghLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRXOt0TL1N59utXtulc8Vm6KkInegGIuL/LUFSW+DkAXZwrWoYRREMpW7qyPPF5zA
	 EE4v/J8XxaaMiCbkhFNqucxatfxsHvn/dBpiqohtVQB8pNo9EPv8p3O4v60HG/bM+F
	 t+bdxWMJXl7eHlP+qWCv7htiqCGIuu40FAe9yJi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 433/737] media: pvrusb2: Fix incorrect variable used in trace message
Date: Fri,  9 Jan 2026 12:39:32 +0100
Message-ID: <20260109112150.281884715@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3622,7 +3622,7 @@ static int pvr2_send_request_ex(struct p
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
 			"Attempted to execute %d byte control-read transfer (limit=%d)",
-			write_len,PVR2_CTL_BUFFSIZE);
+			read_len, PVR2_CTL_BUFFSIZE);
 		return -EINVAL;
 	}
 	if ((!write_len) && (!read_len)) {


