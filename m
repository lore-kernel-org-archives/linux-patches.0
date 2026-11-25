Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625551;
	b=bbZwvkOKJIQcq7GzG0Qr5suRHOa/SUjEuQFJk0Gds2upOzNiAkGgayvEl8jBGJMiM0tU
	 xfbiyx6bdRmtwXoACKEXApIZaoKpCdygDI/RQ5oSElCSUHis3E9dPGAvs6gCKwVwv9Frt
	 jtXc7YURHZJXwLAerNsx2MuhQSaF1lGliWSjRA+c1RqLeLzsLqURp7tx+xfnKzhsNxHnA
	 4sC5VoE7qDl1fiqNltTZoPO7qg8H9dtTf2jHs/VcMZvA2lPS5OnOX3dRvkNuHboJ6fHo5
	 CalzIsRe0MLrPMGEFkfeZzZ1CkRmBWAbO+XVyUkJCvLHJnaRhV77SZAFu35rw0VL2vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQDDDhm4C/Hm6ijPVzA6lu9Yh6K7eWnKLIvxHyv6z4A=;
	b=JGDrc7km9ewYyTNzsrxe6iKub0qx/eisXwgBShC87evIUtduiPnOos/mxydi3edl9Czb
	 yAhyWphh6Drr8tDmoUgpEJI4/W8108ibyFBszinHtKVnMGtPYWpONgZ4e5BWGVQxPjiu/
	 4s+TGo8Uh2TiiDYyMjWNN/lFTvLqj+ZrvujK6N7EFZyl9vCJoRrSSW/wi6PqGgcGLfHwZ
	 DmsBGuYGB38omQB6nyFgXiFpsmhDfTxLL7UrVP4ew9kDRND2orifJoZuVZuceAcAY/Ntb
	 ngPHbzlzs8ltkUgnC3NUzHs4rQcf1tuJeri+j1HwnWaB3AZ2LJdbCyEqJS/TJ4OSEfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J7FwZKld;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034AF606A31E;
	Wed, 25 Nov 2026 16:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J7FwZKld
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5463D1F000C4;
	Wed, 25 Nov 2026 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625550;
	bh=VQDDDhm4C/Hm6ijPVzA6lu9Yh6K7eWnKLIvxHyv6z4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7FwZKlde18iToLXJ6/+sOAUehEsvubcM6BrU++YS86f3KssYC5c6NWERMZA0mCyu
	 zSE6hgIW1y03IekyWrqxTtHixiYReeuj/Jwt1IbzA1ft6O+/4fLlxr5kcqRwkQsI2+
	 pYY0oLsGQXdHLsBvoZkL6J1Vhy1r+jwWEKDRm3Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Zhang <zhiqizhangg@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 552/816] bootconfig: Allow keys with the maximum supported depth
Date: Wed, 25 Nov 2026 15:35:00 +0100
Message-ID: <20261125143901.960627311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Zhiqi Zhang <zhiqizhangg@gmail.com>

commit cab697164b47eecfa2f146024f5d661f99a1a1e7 upstream.

xbc_verify_tree() accepts keys with XBC_DEPTH_MAX (16) components,
but xbc_node_compose_key_after() returns -ERANGE immediately after
storing the sixteenth component. It rejects the key before discovering
that there are no more ancestors to collect.

For example, a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p = value can be attached
to an initrd successfully. However, bootconfig -l stops listing and
prints "Failed to compose key -34". In the kernel, the same error
propagates through copy_xbc_key_value_list() during its length probe,
so proc_boot_config_init() returns before creating /proc/bootconfig.

Check the array capacity before storing the next component. This lets
exactly XBC_DEPTH_MAX components be composed while retaining the check
before any out-of-bounds store.

I found this issue while reviewing bootconfig's depth handling and used
OpenAI Codex to verify the failure and develop the fix. I reviewed the
change and wrote and ran the regression tests.

Link: https://lore.kernel.org/all/20261104073742.21202-2-zhiqizhangg@gmail.com/

Fixes: 76db5a27a827 ("bootconfig: Add Extra Boot Config support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -302,9 +302,9 @@ int __init xbc_node_compose_key_after(st
 		node = xbc_node_get_parent(node);
 
 	while (node && node != root) {
-		keys[depth++] = xbc_node_index(node);
 		if (depth == XBC_DEPTH_MAX)
 			return -ERANGE;
+		keys[depth++] = xbc_node_index(node);
 		node = xbc_node_get_parent(node);
 	}
 	if (!node && root)


