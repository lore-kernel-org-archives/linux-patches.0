Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF743328E1;
	Mon, 29 Dec 2025 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025831; cv=none; b=RC6oNtJdVtOSf4YEy1hcbWI0z88vTQ0vYo1Ap22JVqmhFI4bHXjoZH0gFyxpY/H9wKVd82fzbZ9i+QVvMagQdnQjuLO8apDD9qspqOJZRdS3tU2OrwAbn8TDh3s1n2qp/jnTtxj6gedrzEK0sr9+1hfNAzaFEdJWa06ksjQ3Hw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025831; c=relaxed/simple;
	bh=G0o8CmFdB/CkmnzHuVnRDzy0UvURe6ex+g2+Fvr7tB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4qzwd0Z53+gSHC+aeHzPra3mejlrj/jpYNA9cAB/hV/Am3Sfs3XU1Bx2gSBhBkNnx8y73c7MvBN9I9LTaNPbUEsCAwmnjcoJdFIw5tw+6qTKkGkpW2v/yL7WHaeDQrCG5WNZQ4XFl42OnkTavbeJpBzX1hi9FvFhysLBC1wmsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkTZFCXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkTZFCXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03999C4CEF7;
	Mon, 29 Dec 2025 16:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025831;
	bh=G0o8CmFdB/CkmnzHuVnRDzy0UvURe6ex+g2+Fvr7tB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkTZFCXL3OJdtGnuAMNhjYiTunUtIVjh4V7zsKsP0neE5i0hItCBD3dPmjlXeF4z9
	 3zlGCcdnoSruCFtZSk2o/XyJUXYpCn2noN0EnS93i00DRcZbGlYuh4SlvWVHGXBUvW
	 E8q5KBQUR/VA+7ZxH/eHvjyicnYaUX1yk3dMo4G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 353/430] KVM: selftests: Add missing "break" in rseq_tests param parsing
Date: Mon, 29 Dec 2025 17:12:35 +0100
Message-ID: <20251229160737.316117091@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gshan@redhat.com>

commit 1b9439c933b500cb24710bbd81fe56e9b0025b6f upstream.

In commit 0297cdc12a87 ("KVM: selftests: Add option to rseq test to
override /dev/cpu_dma_latency"), a 'break' is missed before the option
'l' in the argument parsing loop, which leads to an unexpected core
dump in atoi_paranoid(). It tries to get the latency from non-existent
argument.

  host$ ./rseq_test -u
  Random seed: 0x6b8b4567
  Segmentation fault (core dumped)

Add a 'break' before the option 'l' in the argument parsing loop to avoid
the unexpected core dump.

Fixes: 0297cdc12a87 ("KVM: selftests: Add option to rseq test to override /dev/cpu_dma_latency")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Gavin Shan <gshan@redhat.com>
Link: https://patch.msgid.link/20251124050427.1924591-1-gshan@redhat.com
[sean: describe code change in shortlog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/rseq_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -215,6 +215,7 @@ int main(int argc, char *argv[])
 		switch (opt) {
 		case 'u':
 			skip_sanity_check = true;
+			break;
 		case 'l':
 			latency = atoi_paranoid(optarg);
 			break;


