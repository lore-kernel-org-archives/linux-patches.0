Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4DA46C4BB;
	Tue, 21 Jul 2026 15:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648519; cv=none; b=B6Ow7ijoDPzXnLo5iscHxG+3YF7T6Zh16C3sMSlSyMWtRI6Z5RI56cGb2MfvKlyEU3HPy0pkbiPFoh5+2cm2WJghwpVzpbIoTRN1si6+1tm27Z5E5KaJPzKKLRVbW7RYd/Fem5GCIUo7VkcamWgnjLwjw1rlilh6OOfhBlPXflw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648519; c=relaxed/simple;
	bh=a1flOjoUzeRqGMq2Wh2k1XRIWPbXZLS0Lu8O69Pe68M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoHsPOYf9kxmI0UskI+5gDY89g+TKFOe6pcRfXoNAeLxH0jvNj3sBOBUSBkmettVRYqiRcTw1apyDwXOHDzSru7ioL/PxxjF4B1AFVxdJsBCSA+3LjuVSdEjdfyzWR/8H4yezxMz4qAZGWotq/626JU9VL+dHs+HPorPlxX2MBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlbVLqsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlbVLqsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1752E1F000E9;
	Tue, 21 Jul 2026 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648518;
	bh=NUPA518+nU8z6Cc6P8x5vAOLFQEia6RAuy5X1kW2b34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlbVLqsl7zDC2WxXVM71Z2+LoAn/R4zQuZAKaQUVQzf2EkNG8iJvCN7XK4M79SlAY
	 QFVqf0Dv2XZ4fRF9OdabcICyRT7e05OThHQnkvLsd5Gl6dnpJEvzMpOQgVetwhIGt4
	 +wcNcp0sLhUXMkgoLCn9ecI4ZQRcRANS5ElEZIqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0231/2077] selftests/bpf: Override EXTRA_LDFLAGS for static builds
Date: Tue, 21 Jul 2026 16:58:24 +0200
Message-ID: <20260721152558.124311904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 879daba303f7d7c3057f4d218921621e751f1912 ]

When running vmtest.sh with static linking, the bpftool_map_access
selftests fail. These selftests are calling the bpftool binary in
tools/sbin/ directly, which results in the following error:

    error while loading shared libraries: libLLVM.so.21.1:
      cannot open shared object file: No such file or directory

To fix this, we need to also build bpftool statically. That can be done
by setting EXTRA_LDFLAGS=-static.

Fixes: 2d96bbdfd3b5 ("selftests/bpf: convert test_bpftool_map_access.sh into test_progs framework")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/714556da329c812988010ffe53173d9152570a78.1778669303.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/README.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
index 776fbe3cb8f9bd..37164322a1023f 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -77,7 +77,7 @@ In case of linker errors when running selftests, try using static linking:
 
 .. code-block:: console
 
-  $ LDLIBS=-static PKG_CONFIG='pkg-config --static' vmtest.sh
+  $ LDLIBS=-static EXTRA_LDFLAGS=-static PKG_CONFIG='pkg-config --static' vmtest.sh
 
 .. note:: Some distros may not support static linking.
 
-- 
2.53.0



