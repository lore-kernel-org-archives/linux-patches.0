Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011EE2DF9F;
	Tue, 20 Feb 2024 21:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464157; cv=none; b=RSyLfZdCVnO6+kOv0KRD9W4XTCujALns29IPiyIEc/Im4y35c/SWZ9dFzQRqloydwWO0+0YxCzCL5PKWx7QoDCohg8yCAsCPvECbrI3sa+/ZR4csL0mZ0Ovm4B5jCC4UsNfEpj0jwoeGmz1roiej3MDKQ3+vWDyAYeImdPE+i7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464157; c=relaxed/simple;
	bh=+9LsiRdY5LYP8kLZchlD4hB3ycK6eiASZHELVujtfFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMSPU3g5DRbmRkiZFwbORresbbcj9AjBbUOd0fCyVVR6dVMkET2QWplz7/CHkHt/X0oOztoP/bodhoZolvUDqcgRqR21mPv/brcCaQKuj1PHb8ukL8tQOflMNLaBq+F3ovNtsCdd+n+f8HZB/kVbXBUfuxf2AMhnYGHY4EBFiwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDXPsXR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDXPsXR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FE7C433C7;
	Tue, 20 Feb 2024 21:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464156;
	bh=+9LsiRdY5LYP8kLZchlD4hB3ycK6eiASZHELVujtfFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDXPsXR+jatJfA1OUM7nrufuekktN18l1+tf/kE80nGH7oPPe8KkF7yREX+COzL3d
	 6CV0SpLN+07MtLuW6GjbpEXf6z7aoBHUWIsHb9ZWst2rXLlxgK4VWSdI1apiI9IQOL
	 Q7V33HcUxM9ZsZqBtgAvwrGrHGtBvq+ycwh2QL10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 268/331] tracefs/eventfs: Modify mismatched function name
Date: Tue, 20 Feb 2024 21:56:24 +0100
Message-ID: <20240220205646.307149521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

commit 64bf2f685c795e75dd855761c75a193ee5998731 upstream.

No functional modification involved.

fs/tracefs/event_inode.c:864: warning: expecting prototype for eventfs_remove(). Prototype was for eventfs_remove_dir() instead.

Link: https://lore.kernel.org/linux-trace-kernel/20231019031353.73846-1-jiapeng.chong@linux.alibaba.com

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6939
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -856,7 +856,7 @@ static void unhook_dentry(struct dentry
 	}
 }
 /**
- * eventfs_remove - remove eventfs dir or file from list
+ * eventfs_remove_dir - remove eventfs dir or file from list
  * @ei: eventfs_inode to be removed.
  *
  * This function acquire the eventfs_mutex lock and call eventfs_remove_rec()


