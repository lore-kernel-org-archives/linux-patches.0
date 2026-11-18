Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016236;
	b=bqyYFhcMboAx45+Wtpq0dcGECT/2+u8OwzsGgJk6hnqD6QUYQXKgoMP25eG+AcnFgzyF
	 BfOe9nlnjyLCZjk7rH+8iy8Ecmkm9il7BCUpN4g68TGp9XHUux9iiIU6Cgpmck2zjFUwZ
	 l7Uep4xaxIhcwqexH4NDbHYICrMz3VyK+6p/EH+68ca0kSj7CuY4RgIiUq6MwoX5d3+AT
	 o5tDj3T44SSMJCXklJJW6T2mk9BdlwtsDsL/8ChxOBQBy0E7MRX83LK6iJPwEAF2e36l6
	 EpU81+e6TiOAsYX+79KBVfDR4euRr6UZIbQiWqdH1ULeY1UwupGNKuFw27iBcKXtbcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJPd9wIq+jd3s0mSvNaHWTtIeT9YZNKkGtODKEBdRxM=;
	b=RDkmrTyJUo3hSI77/oeVChuY8lyC2wX+g+PlLbbpkiEzYno65EueirqKm2U9E8cvUUqo
	 kR2WONUEBeR9NZYVsK2SOGYkyzw8N9u2CqPJ62UDFQPAABWItnPru6C3IYW6WrNBRR18C
	 U1DsTBoA0N4NxKygncbGE7HTjBPYsRrRvX2QH1DFuRIod+xG/jC6bDHT4I99ilRMXoEtt
	 ftHVKzmuaQjJZ0iKf+ZdlkX60llDyKIXvNWqhuKkNczEJ0TX2/SKVnYDul6V+QR/4qm3B
	 EOeSbWYgSZ5NCv01T4T4q6SCSRWEvdxk1G3Z0QYEeQEXqSiUh+mo62UeRa6cRzOiu1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w+XCTtR/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D998A606A31C;
	Wed, 18 Nov 2026 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+XCTtR/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFA71F000C5;
	Wed, 18 Nov 2026 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016236;
	bh=rJPd9wIq+jd3s0mSvNaHWTtIeT9YZNKkGtODKEBdRxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+XCTtR/U41Z2ns2iyC8u1Bnfa5ygpT6L/3hn6yPjuZXMrlVoBGBScnYhPqlGRp5T
	 fvJ8aKouH+SGRCG6GwBk4p5JkMuoqqhKMYt9ZddOQI4o2rtCnntDAmYtzEmmjd+DaJ
	 Mpz07y8tLNmEiMTGF2ABLow2oei8kFhgZp9fQs0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0456/2651] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Wed, 18 Nov 2026 15:28:16 +0100
Message-ID: <20261118150304.219525930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 44b14ff4aebeae98663d0fd424b4ef88237ee981 ]

The custom lib-%.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule, so
"make C=2" silently skips the two libfdt objects. Call
cmd_force_checksrc after the compile rule, as the standard rule does.

Fixes: aacd149b6238 ("arm64: head: avoid relocating the kernel twice for KASLR")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260901140326.3812068-7-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/pi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index be92d73c25b21..96243c291e39d 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -34,6 +34,7 @@ $(obj)/lib-%.pi.o: OBJCOPYFLAGS += --prefix-alloc-sections=.init
 
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 obj-y					:= idreg-override.pi.o \
 					   map_kernel.pi.o map_range.pi.o \
-- 
2.53.0



