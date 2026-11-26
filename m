Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704539;
	b=CeceuZgUkbcEsbCVWPKHYaaRAxpBaTwLlTITnpG3GBj0CmLmQO6ABQFeXpLChTKGuixB
	 7IO27LGyuqyx57/0qJzLkxO2nxZ641ESNrVWJl9vdmm4tQv669jpV0M9+vTZIKUthYO+R
	 A4Nxgeag5NUDVWJH85O9UX5mppFItq8aW3vMKQWJJPqKV/sFaztf+LrOL6bvcH9IHRB8d
	 bPzfQgtGorY5K48TZZ6izTW4jzldhpTp76kQaEG0PrcrRmJRVO9m5nn1ged7hwv+FkS/S
	 3udLz+0weLSVfBaWWN5+qTAlyIZ2OSTu+R+3B94UnFTvKYakuR8Ya5PZ2vpDKWh50UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9c2m22/43t5x+10Yk3M0GafCEPm6l+lb4SSs7DWfyY=;
	b=1I1J50mTVIxVZyfwVQbsH7eksb/8DGKeeJglFTusBF4KQ1hcm3/xMeH9JRk98xmnympk
	 HgwAE+35z6FmtN9hyslHUnMVYyjvUgYuf03rpJjtK4VPDqQOchDI5KLBLMdrmXkHolbCz
	 1fxdPQrsrLVBR8zXUyyDZCQ88nbjvMAVbHQJlteKKjOfK20dz/yzwJk89KySkKj5fQgbp
	 0AS9qsrJESVE6wo1zIhvajfn/u3jJ+b2uC+O2mxQkc1IkKzd4cNM50YViw6vloJdz/rRj
	 RYtsh7sQ5gbYMUXX3z6dkjylW4Q4bvrUfuX5/dnF3+Pt+Levt7/HWJ4tqwSAnXFQ9Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0vWIwml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F29606A31C;
	Thu, 26 Nov 2026 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0vWIwml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECF51F000C0;
	Thu, 26 Nov 2026 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704538;
	bh=y9c2m22/43t5x+10Yk3M0GafCEPm6l+lb4SSs7DWfyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0vWIwmlCTMmiCIQIKmYS+yUsm6pqi4uwZsIvovYEFQTKKSMSY/31DSyrCyBxla1q
	 FxKlbM/MtH2yKKqA/J5FiS/8fXvxy04SMYnJvMqmjz5wx3Iyr/e1z4ktn/FeNXlGt6
	 RyA8wnhvjkj2Q30cy9PLnGmN6GQXcooMA0a/sPS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Zhang <zhiqizhangg@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 142/265] bootconfig: Allow keys with the maximum supported depth
Date: Thu, 26 Nov 2026 15:37:52 +0100
Message-ID: <20261126143614.949734445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -236,9 +236,9 @@ int __init xbc_node_compose_key_after(st
 		node = xbc_node_get_parent(node);
 
 	while (node && node != root) {
-		keys[depth++] = xbc_node_index(node);
 		if (depth == XBC_DEPTH_MAX)
 			return -ERANGE;
+		keys[depth++] = xbc_node_index(node);
 		node = xbc_node_get_parent(node);
 	}
 	if (!node && root)


