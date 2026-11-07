Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061829;
	b=VecoVMgnaeVWIl+NELjm5jPcN1mL+xdksUX8EvwEwTyomaFlx99YdpJ9WvXLkqb6LpmE
	 MVZwncvibcxsPej0WJKrMbMWF2y0AehP+0IcXPpMG09okdZoiqtEsGqCAXPXlR+MXeb5M
	 5ChT7l1+1u0Gq7XGmz0Uxmq8SkFzZrJyBeXMnkvbWG9n6p4PSnG0eG0qKt3X0Uo1RvugA
	 QMx1/uZ0JVj2J7CFh9QZVeW2Y/dSK62IaXJe/u0auyLWohXV+bs7cmyQY8hv6+yHo8yR6
	 MIn+MOgW8cuU0Ve9vsvfUOenJQlmT4gl5Y1g8TrPpfm7/eubGDso7XpvILEKJrvuXEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QifpIns6P/+22wsGW5N9y5CcexsocDAXdiDDn5Z7D4M=;
	b=uAhyFGyWfpqpML6mAKIFZeLsb3lJdOIQx/SU7H6NUXNAmCcaPQEhPW6LKXA9uVyukzmd
	 CT+iZ6+EvfZ4VT0l+8lliZuzNobybXjN5Q0EHOUK7Jrv2fxlIQI9NI4Km7VLYPRU0bh8L
	 ADBXizCa0/5XAg056D+GnwLMzLkYyONrVxOyllSVbP3FJ7mNmvtCkFSahGtaEOaAlxFEV
	 tKTDdrl4fZX87iPomgqKDa55pgIlf5dt+tWnGt6e8OhtZWcfqk2BKac7b9PMAav4yhDaK
	 Ut2iMhihGRtPkBGDFvHk5h+Dq906uwTcowpKwAegoQfnnTgnSPr0QsUmSWJJORsiibw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FhAbxgsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EA9606A326;
	Sat,  7 Nov 2026 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FhAbxgsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0123B1F0089F;
	Sat,  7 Nov 2026 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061829;
	bh=QifpIns6P/+22wsGW5N9y5CcexsocDAXdiDDn5Z7D4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhAbxgsQJRtOQC2uw7+z8aq/KUb5aCeKplWmZFv98z5xO4m5BOdZzcqOmOL8UVxak
	 PpHqO1b2g32tj/ZQqQksLmjgx4ibhEiQARB2COY3a90RRfyE9nHeuPJGB93wDLMxfG
	 P/HGghVws759X31KZUfLcT14VBihTQN5iTWpbwBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0851/1536] KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected
Date: Sat,  7 Nov 2026 08:47:47 -0500
Message-ID: <20261107135021.449266839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit cef48693da1e964e9f192bfc16cd0ed287c48337 ]

Preserve the negative return value from __vmx_handle_exit() when a bus
lock is detected, instead of always overwriting it with 0.

The purpose of bus_lock_detected handling is to force a userspace exit to
inform userspace that a bus lock happened. The negative return value can
achieve this purpose, and changing the negative value to 0 fails to return
an error to userspace. So, preserve the negative return value.

Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260805034602.5B2BB1F000E9@smtp.kernel.org/
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-7-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7e098fb60bbf7..b6361df62269f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6625,11 +6625,12 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * a bus lock in guest.
 	 */
 	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
-		if (ret > 0)
+		if (ret > 0) {
 			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
+			ret = 0;
+		}
 
 		vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
-		return 0;
 	}
 	return ret;
 }
-- 
2.53.0



