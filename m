Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057769;
	b=dQKaIe3svQiBcL252Y2AUoXGpqst9kQddb1E4klj3fRt0xaPalX0hJT9Fb/lNN6/i8pC
	 2ZWg23+vz9eBaymNSHQYZKr+H90bozlCXUCJ92fBasTBFBGD+yob8d628Gf9c/vh8Z9WU
	 MsE5d9kvtfgTsH3D8jxj46QKx8Wj8P6+lAJrSUIOC6xkMycvi6xz7DmALEfPBcpAqMCvr
	 asuLyC90RPpyyKVVKBKAULmkJOR8qegycM3gYPLRY9HLAfza3Q4FBuM9vK38zQufgFTCI
	 rKsq1xB3hh+McXidCH7QG1kDvJtoXz9dNTy0NZtstvSHTf2lkdT33cff1t3zaWc0cCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qhBoe3JSDV+fxtXFv3S0U18cTY7eckwMwE2Ilz3OmcA=;
	b=kPDup4w0F4s2TkZQhshZQ9YfBQNBVzkEKBpxdA4u9A2/0dKZpP85LqhB1fg7ZyTiyoyC
	 OhMqaYxoiWifAmjFyhj+o9q368snARGsPXCF+IkO6/mgfowPTMV+3kvI1xdeqy2/NeKWY
	 PzognqSc7ONu4nm7QIzjpBQFFI4nK2Zq3Am4grPH17EgcQNaXcPIWx0cNTkAGFP3fozGl
	 S/o6MpGd0UaWUXWhtpCS5j5b13Bd/8HJnS6bPDjwMrgyiMANi0WXUYv6+rO6NpVhJ/9yT
	 FTvlQHzHyJV7lfdQ26rDHEmLgkg8C3CDE8fwVO80ib/j0dsYD3PO5hITbF5ANno4OPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ks+j7Wke;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DEA606A325;
	Thu, 19 Nov 2026 03:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ks+j7Wke
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39141F000C5;
	Thu, 19 Nov 2026 03:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057769;
	bh=qhBoe3JSDV+fxtXFv3S0U18cTY7eckwMwE2Ilz3OmcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ks+j7Wke+giSJFY0f9YdwaggGV/XQLOtYybeZc3sgN/jQlq9ivJHov77PjxAAvt/e
	 vn8JJ+yvxo7D7E0+22E7DHNO6jA2YsWvmk+c6H2hLuj0yPlXR8077A7gztZAPY2bHw
	 GHI8odwA9pEZKZC2BHqnD9keGseXLRjuCKLwHWyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 0247/1848] s390/probes: Fix wrong opcode for cgrb fixup
Date: Wed, 18 Nov 2026 15:38:05 +0100
Message-ID: <20261118145922.311287055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit d7ccab11a13475e656b9d2277900422c1bfc12c5 upstream.

The last byte of the cgrb instruction is 0xe4, however the probes code
compares against 0xe6. Fix it.

Fixes: 6b169ac9b434 ("s390/kprobes: add support for compare and branch instructions")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/probes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/lib/probes.c
+++ b/arch/s390/lib/probes.c
@@ -99,8 +99,8 @@ int probe_get_fixup_type(u16 *insn)
 		break;
 	case 0xec:
 		switch (insn[2] & 0xff) {
+		case 0xe4: /* cgrb  */
 		case 0xe5: /* clgrb */
-		case 0xe6: /* cgrb  */
 		case 0xf6: /* crb   */
 		case 0xf7: /* clrb  */
 		case 0xfc: /* cgib  */


