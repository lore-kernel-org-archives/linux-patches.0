Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213357;
	b=e5hckPvO2RUOE17C1fHYMgxdDFZDmDFoQTORseqW7OfEIi2kwdnhmp717lbVHiV3sWX0
	 /GyYRb3W9TW6qOcrOznAMPVsQU7Vfd9fmFZPM1u9/W+5lmfTYsD/LNKpM7DQX3gBjqJFq
	 h9OFGibeyv0S0Az36U25soxJDrblksmjH5LiUrIib84qSbvIuysgwIYta21s7VMxbAB2D
	 f3+0Hzy/9z7puDMJTHQ1B7p/qZE3Muqk5s03jrsu/yENdbMkKiCYfvoTzaYFVgkJyKSCF
	 RtRfpjDeALdlVS3H2UGqjZhXTqo6bmuzNkUypVfXbKMIMxTkrJsnzv8iAbaUpKLTkVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jJvZnWEa/Mxa29nSoBI8giskcnlK+MfhsxZZyacOgc=;
	b=W7AleHdLhKUk9kq81xaBQAda7c1pnSzcm08nlhWWXancaAq0ePl0BN4dvvytw6iynj+2
	 k14tkGENAak6OEnizYnZEhpQs0vjGXqT6sgNvqQWr1OjMKLHuuASYClZaLDdMirxyMKLY
	 vUsl6f3OkngyXC58sthQkint9N9Iqde+n+9hzWYMNQpsW3SZWVWHQV9hWZ/jbzgqenXR/
	 qChmnZD7xqeL3IDiilmGLtBwyw+t/1CJv3rUkBl4vpNnCGiF+KCUnkluut7oAAJ3i2Mu6
	 K88//7aT26vEke8ziRWDcJr7d2UsknVs3mGVwiS/NnlTDBBZXgevKY8kqlgPlK3bILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlVZhfvk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3CA606A31E;
	Wed, 28 Oct 2026 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlVZhfvk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF111F01825;
	Wed, 28 Oct 2026 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213356;
	bh=1jJvZnWEa/Mxa29nSoBI8giskcnlK+MfhsxZZyacOgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlVZhfvkMLYQRGXlin0XMz0SqlAWsKE8m5pNtJirWDHFaAo0jexn8C6LLoAQ/DwZu
	 WexHoO54VUXKAqRiFMkmILMNgmQSMUhp48ob8pu/iZw70xZgd8lDEGK7kyLOxu6z0t
	 SzlN4RinNtX/mpYznXAwkAw5s1NJj1o4DrTB2qc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 0475/1887] drm/i915/gem: Prevent overstepping exec array boundary
Date: Wed, 28 Oct 2026 17:42:51 +0100
Message-ID: <20261028170510.053539302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

commit ebe162db655881a38de43301151ff7ac940602b5 upstream.

It is possible for eb_relocate_parse_slow() to call kvfree() on
entries outside the original exec array during following
scenario inside eb_relocate_parse_slow():

1) eb_copy_relocations() allocates as many as eb->buffer_count
   copies for exec entries;
2) eb_parse() appends up to two VMAs, right after incrementing
   eb->buffer_count;
3) cleanup under "out" label uses this incremented buffer_count
   to release relocation pointers from exec array via kvfree(),
   not from VMA array.

To amend this problem, ensure that relocation cleanup uses the
original exec object count, excluding the VMAs appended by the
command parser.

Fixes: 8e4ba491b0ba ("drm/i915: Parse command buffer earlier in eb_relocate(slow)")
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Assisted-by: GitHub-Copilot:gpt-6-astra
Cc: stable@vger.kernel.org # 5.10+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260911061145.3535489-1-krzysztof.karas@intel.com
(cherry picked from commit 2a0158925fb943c7ba8f3216e2734952128defc9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1752,6 +1752,7 @@ static int eb_reinit_userptr(struct i915
 
 static noinline int eb_relocate_parse_slow(struct i915_execbuffer *eb)
 {
+	const unsigned int count = eb->buffer_count;
 	bool have_copy = false;
 	struct eb_vma *ev;
 	int err = 0;
@@ -1854,7 +1855,6 @@ err:
 
 out:
 	if (have_copy) {
-		const unsigned int count = eb->buffer_count;
 		unsigned int i;
 
 		for (i = 0; i < count; i++) {


