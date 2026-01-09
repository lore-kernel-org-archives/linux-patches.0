Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029235A95C;
	Fri,  9 Jan 2026 12:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962353; cv=none; b=PmmdIT1d7boG0gVmhs4ZM/5FTgOVSpSWYcb3LcgVUxZcVeAuL7QiLlQmJHTfQXJju2D3TpWT0dJeMg0fwrFOwhEhCsECNwRQV3n8uxJDtiO4xEotfDda67x0gWHP5DPn3qVr6GK9zmRhlJSYyy9xTO0IVwYa/vmDf4euDBhqY64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962353; c=relaxed/simple;
	bh=yPgFNXV8smKwdXm33l5vOZiedM+NpTufl5Kc/WD1mTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbqtxt/Jh0ib020F08p9b+9RE/UJ4VCf6QmKWSbBnWzqnfgStCjEcSl41Ev7QtfuSVVNYJ+K0tt4EGhjRO9NbqCJzlrqLTwV8uZ+gRA6HKR/LM8EDCw5d/Obw5xvSjSD9sqHLEhJ28EOiG5q78dUKxuGDm8FvmKUUTEO1nah4Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C25t2pP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C25t2pP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF75FC4CEF1;
	Fri,  9 Jan 2026 12:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962353;
	bh=yPgFNXV8smKwdXm33l5vOZiedM+NpTufl5Kc/WD1mTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C25t2pP5u/0ZTwIzPhRh1MWd0O5ll0gegqq5RTXoQDtW3kiPVctYO0SBc/n0fjCeS
	 OZhQO/qL650Eio/RneNhv/7KsTY4XiNrkZkKoB3ZZ+nbNzXSd8rBceaPIs3JoQImlN
	 Xjc+f8E/TGQqk1vL7SKgxp8SjW+fZ1hM8ZDZRLi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 335/634] media: pvrusb2: Fix incorrect variable used in trace message
Date: Fri,  9 Jan 2026 12:40:13 +0100
Message-ID: <20260109112130.130880718@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3620,7 +3620,7 @@ static int pvr2_send_request_ex(struct p
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
 			"Attempted to execute %d byte control-read transfer (limit=%d)",
-			write_len,PVR2_CTL_BUFFSIZE);
+			read_len, PVR2_CTL_BUFFSIZE);
 		return -EINVAL;
 	}
 	if ((!write_len) && (!read_len)) {


