Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ABF248191;
	Tue, 29 Apr 2025 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946351; cv=none; b=A5u4v44ky2g43pjl4SZi/8sp4u1PWiVUDjesrllU6kii9KoI9QFuWq4g4C2xmlC3qVWr6OHWM5lN7w7KcDrMEYiZVSQoff8fvmdwGKby45YZvJtMUOI2iLqyGwNRJeNCD5EF9kWdHvEvp35IUb5CaCXDOszOlx/gcqhc8Mr88bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946351; c=relaxed/simple;
	bh=MqK080vAUatB3N/Q90G5G2BLyZlFBRRTC3rvZzJnaNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTf9JtDGHY+NS1NPp6ZaPG8yImNYSfueRIaxJd+swVLoFQ+HnjdAFNxIFVDLrJIeLSa/Z0zCUknHY0sakN8EF65VCerFmwhhFf+XxORpXJCCeyNw//7R5JYrhyTOxDuoMV7yd9KmSX+kd7PRFRf8aRIELWQl9JakyfLZpEWQmH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5h/Knw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5h/Knw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57554C4CEE3;
	Tue, 29 Apr 2025 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946351;
	bh=MqK080vAUatB3N/Q90G5G2BLyZlFBRRTC3rvZzJnaNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5h/Knw9hZMMCNkJRaZ4pGGP3HrNtW6HJs0T1fUurX1AW1p//XPv4youegWt2ff0J
	 8aVnx8kXW2Moofr5XGubdGID39KlBIDdGz0GPwxga4881yzm7uxfcctskfB/2mWjA4
	 NDLwQLYiANHculisMTcEzSqMvPkdYKHqCxWYhgAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Michael Mueller <mimu@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 238/311] KVM: s390: Dont use %pK through tracepoints
Date: Tue, 29 Apr 2025 18:41:15 +0200
Message-ID: <20250429161130.772611976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 6c9567e0850be2f0f94ab64fa6512413fd1a1eb1 ]

Restricted pointers ("%pK") are not meant to be used through TP_format().
It can unintentionally expose security sensitive, raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20250217-restricted-pointers-s390-v1-1-0e4ace75d8aa@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/trace-s390.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
index 9ac92dbf680db..9e28f165c114c 100644
--- a/arch/s390/kvm/trace-s390.h
+++ b/arch/s390/kvm/trace-s390.h
@@ -56,7 +56,7 @@ TRACE_EVENT(kvm_s390_create_vcpu,
 		    __entry->sie_block = sie_block;
 		    ),
 
-	    TP_printk("create cpu %d at 0x%pK, sie block at 0x%pK",
+	    TP_printk("create cpu %d at 0x%p, sie block at 0x%p",
 		      __entry->id, __entry->vcpu, __entry->sie_block)
 	);
 
@@ -255,7 +255,7 @@ TRACE_EVENT(kvm_s390_enable_css,
 		    __entry->kvm = kvm;
 		    ),
 
-	    TP_printk("enabling channel I/O support (kvm @ %pK)\n",
+	    TP_printk("enabling channel I/O support (kvm @ %p)\n",
 		      __entry->kvm)
 	);
 
-- 
2.39.5



