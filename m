Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA8836F421;
	Wed, 20 May 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297123; cv=none; b=eKgof9mQeXHeCAD75sPz4lQtETxMoaI2AoQgaCpwOGPaZoVRF5hAN07I85ouZNNUjwGmF22xNRzg7RjOIfFszSiSLJvH8sSQl2EAmF+4s8tejX8zm7xyI4HUdU8RpPsNdViL9qSyIP/GShIR4ReU+Eggy3VezIg0gDAx92Lh25I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297123; c=relaxed/simple;
	bh=cS3vdU8hRhwwP6VXyQwM1KIFkPlOG+bNb32wjkcTq1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjBBhtYYACAX2dsOn9G4yXENUmv5sGh99+glhprEtXmLjW+eyheJlyu+DeYI3yvkfuEiDIj762CRfEKutXdw0JWeZ20knvSIsc92PQfEvC2QEsqz77x6DCv3gI5BHKVnjBhmID37IRlBkCHlKVnS7iCX/1PVP2t6Uk07j/bLFn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfDuTVca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfDuTVca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408ED1F000E9;
	Wed, 20 May 2026 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297122;
	bh=Y84VLimB0UUheizCqJJB+OvpPWSJDv0jPf3O193zk48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfDuTVcacqiO8ECmDzzjH5gfc0VfFIZ7pK2a3jSUNTMe/u1SAa8gBbOG+od20l8KY
	 /ADIvza7MayA2JUtTRWjsISTB7MjUy0DG/BJa8lSYkXtXlP1CDDKWbWXfkHhwt+MxM
	 /4c7OjIFtrpE1yht5DcR7kw+zDj+p220IC4zm7I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.0 1060/1146] KVM: x86: Fix Xen hypercall tracepoint argument assignment
Date: Wed, 20 May 2026 18:21:50 +0200
Message-ID: <20260520162212.221555323@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

commit 2b72f1674e427c56e3772c5ccf785fdda2138820 upstream.

TRACE_EVENT(kvm_xen_hypercall) stores a5 in __entry->a4 instead of
__entry->a5.

That overwrites the recorded a4 argument and leaves a5 unset in the
trace entry. Fix the typo so both arguments are captured correctly.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Link: https://patch.msgid.link/20260512015313.1685784-1-maqianga@uniontech.com/
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -154,7 +154,7 @@ TRACE_EVENT(kvm_xen_hypercall,
 		__entry->a2 = a2;
 		__entry->a3 = a3;
 		__entry->a4 = a4;
-		__entry->a4 = a5;
+		__entry->a5 = a5;
 	),
 
 	TP_printk("cpl %d nr 0x%lx a0 0x%lx a1 0x%lx a2 0x%lx a3 0x%lx a4 0x%lx a5 %lx",


