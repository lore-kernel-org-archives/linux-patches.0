Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68FD140E3D;
	Thu, 11 Apr 2024 10:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830944; cv=none; b=TZcTYXaolH8UGPJBEiuCtZ/QqpknQXSURH6kf2v9hFdQjnAAcy3NEL/lg+bhifI6c21JFKqH6dPHxJFtSsPRICGIl6K05uvhEMMWhyC3KM8SZMWFthF0i6gTxInF1YDR6oJuOlZx9Ugg0xcmvBpixtB9NISZeZ1Pvm7tMG3AxzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830944; c=relaxed/simple;
	bh=y89qroPzJvMFcfpoy+TYHxLkZXoWUbVtcE2LuV+40Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvJGWYt9Ehrq8OnQW2mpGDB1CQ3G+2a8e77zFexhs32B2I8sGrZNakj/8MqfKJvQMPvJCGsFVZmkRHLPf07ri9lKd08PdxV37a6oB6MWyj5DaBX4OKsCtKnEgP+bUM8zcT+HrjDnjEEzUJjhs0m6XfcGVZg6o39uaYhcRM92FZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ActxKux1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ActxKux1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345BFC43399;
	Thu, 11 Apr 2024 10:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830944;
	bh=y89qroPzJvMFcfpoy+TYHxLkZXoWUbVtcE2LuV+40Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ActxKux1kJ3Gm+enYqXKYQx32kRZZ30ucR0EidWvH5ApvjaaA3X405ucQ0lWoaqaY
	 7l6RxgP3xl7md15CLOuYqtJbM48vaHaH5CIpSB1QGyb0DDrAwAQhGlVtvgTH4aacwy
	 1+Q3/t03DqmmNMqNtJ4wW3Nco1nfYlxcHLhGDjXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ulrich Weigand <ulrich.weigand@de.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 171/215] s390/entry: align system call table on 8 bytes
Date: Thu, 11 Apr 2024 11:56:20 +0200
Message-ID: <20240411095430.013132399@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 378ca2d2ad410a1cd5690d06b46c5e2297f4c8c0 upstream.

Align system call table on 8 bytes. With sys_call_table entry size
of 8 bytes that eliminates the possibility of a system call pointer
crossing cache line boundary.

Cc: stable@kernel.org
Suggested-by: Ulrich Weigand <ulrich.weigand@de.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -1542,6 +1542,7 @@ ENDPROC(cleanup_critical)
 	.quad   .Lsie_skip - .Lsie_entry
 #endif
 	.section .rodata, "a"
+	.balign	8
 #define SYSCALL(esame,emu)	.quad __s390x_ ## esame
 	.globl	sys_call_table
 sys_call_table:


