Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3608383BA;
	Mon,  1 Apr 2024 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987288; cv=none; b=S1b8DqKRLuEbkIY4rjCjU6Sc0/NrM6P4r5XLo0HwiuB3Ib13oDd0sKURW1bgwJe4QkyjrsFYTm8b2kdneUZMSI3z8TJiqq5HGr3/6KpmqJ9PfWC8KYMxvgk7inYgbZJknIWfFq/N4FV/UUIPIf+GCH2fb2KKykwXmCF+5+tMlcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987288; c=relaxed/simple;
	bh=ErLHhZxKMV/9d1Plp/I+UplyTuOGYdpViS+j7immT4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rven6t9tXTlF6o43ItJ3PbbVxwoIOEBz2fN7gi4Y5INnkVnU9RX81Ug7XuMfbMzoZ6XC870r5iltVi83ekiXktpcYWEZTNcxqhajEa3q+vB0ywegKKRSmgsZdpW1M+HuNo8jnGzalJl8FtkLzrvH0ifUzOWSWrpxwzzJDg4x24k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdnxJvJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdnxJvJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5BAC433F1;
	Mon,  1 Apr 2024 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987288;
	bh=ErLHhZxKMV/9d1Plp/I+UplyTuOGYdpViS+j7immT4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdnxJvJKmJrHZ45n4zGX9H1vFL/qjabzK1Ga7ZYTIugQ8V15E1bxAf74fqM/DkRXr
	 ALWBtkYIylsE0Mj1GjfPBzB2uQA8CxKSc+SxCfnDTocgayeQZ84y+s4oZEyy6lopQk
	 8WHeVesd/+HlvF/ODaFbkBfn9Hu61i4fBY4Rq4F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Audra Mitchell <audra@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.8 242/399] workqueue: Shorten events_freezable_power_efficient name
Date: Mon,  1 Apr 2024 17:43:28 +0200
Message-ID: <20240401152556.399906474@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Audra Mitchell <audra@redhat.com>

commit 8318d6a6362f5903edb4c904a8dd447e59be4ad1 upstream.

Since we have set the WQ_NAME_LEN to 32, decrease the name of
events_freezable_power_efficient so that it does not trip the name length
warning when the workqueue is created.

Signed-off-by: Audra Mitchell <audra@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7186,7 +7186,7 @@ void __init workqueue_init_early(void)
 					      WQ_FREEZABLE, 0);
 	system_power_efficient_wq = alloc_workqueue("events_power_efficient",
 					      WQ_POWER_EFFICIENT, 0);
-	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_power_efficient",
+	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_pwr_efficient",
 					      WQ_FREEZABLE | WQ_POWER_EFFICIENT,
 					      0);
 	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||


