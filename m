Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59F7215F7C;
	Tue, 29 Apr 2025 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948168; cv=none; b=ruBBOnO1VmoLIF4uc9Ip/pryu1s2flUJGVeH3i6IJnM8pMNEfNw3stcMnWTQzkd4eRkmvYv+qL/fgdG2Jz2VJFLWdBgxBfLrigTjK6pIw8NUsOfhcDhPP4y4sqUBYopnPhN43uDwk0D5yFV7n7sM4xg0YNWL2HLk2CbUHRqObak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948168; c=relaxed/simple;
	bh=XKWLwaoXubVH/19XUHJGFRWdyizHoVvpTEU9K2xNePc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KBWEK79/q1Sq/5OgljXJl7BVQlzoOB6e7QSF0ou3KlG5b5c+B8l/UpAT3UJqjFM+FTXCsLdTKOKidnXU67v9PiHxe69Gh2ufJZ8DrcDHKjNYIZvciM075pV8v8hMP3HflY+LIfIIeqbsdgmhSx71ndsGfmPVQ7xrXw+/2etRvkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYtpDwfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYtpDwfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD8FC4CEE3;
	Tue, 29 Apr 2025 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948168;
	bh=XKWLwaoXubVH/19XUHJGFRWdyizHoVvpTEU9K2xNePc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYtpDwfjh9iGcqe8PtkIygXJctCTk8INB33MdJBcEjhQ1StSlc+XfukA8h5WJNrM8
	 6dHDWbglyZXwHtMan2jC9O7W1PWI27t+NkHlfFYoolPEVI7G5IRaRgv14NDSoJ6L1f
	 dMROMIZh34Z2bkTH2prPz5d24bmTDLVO58m0t/pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Michael Mueller <mimu@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/280] KVM: s390: Dont use %pK through tracepoints
Date: Tue, 29 Apr 2025 18:42:22 +0200
Message-ID: <20250429161123.351613347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



