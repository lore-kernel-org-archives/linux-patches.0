Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056546;
	b=sKMmViVwFp1h9O6DCJ77XvpR/s7d3KeUvIAXqQ7EpBsDH6I0PU1DKeaqqMOT/2EtcUmu
	 xVO7avCh/GAe7dFOkwzIuHAVArgdI2EeNfq4hoNHwC8krz42Eb9OggnBUnona2Jx+CR0Q
	 VBQO7wlz8U6+Tu/66sGYE485ZR+KZr+8G4rUi28+V+KJfh47QGhDvO5iqLXj0miKcoClq
	 2rt33jl05p3jRN5rWWam3ApVVCHCyGxPd/y8UkI4/HhSYYwnDHP3+spzYEB0OBiCG/e3e
	 1RGJIX72bptl6KY0c6q7oPZuG5+XbEdH7lCn02AwEk4IylvX2UOv9tl20p81JDhNfLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2cereiqLq/m6vgzQ7cQWRESzEhlLd3gsDFTqt/9l5HE=;
	b=gYu9ENARnBBtLnIDjGf+0vj05BcMzFpI8SqAbmwx6AlUEh5gH+zWqF+dfZfIEWyvrC2M
	 Vx9JfBO+BUhyhlMzy0Ld6d82IQmqHujsOCpt2BGK7c65fpk4L9V8Js4yp/xiLl86cr6Nr
	 jcZ2CmR6Jhig7jGUmBKRwuWTC59JpwhBtOOMweowAL0iV4ytbJyK5Cjzg+VHnEVo2a7gb
	 Qd2jpw+sbPAmDOJOaNGO0RRvZeJGfjMjzH3ojvwaUdaY4v6eBsAkJL84oWkbLivZD+5Aa
	 WXSFX7cI6LJ2hGW95gzD3N1WpuAEynRkMGTk5crCa8PMIrQaIJTWyy8qVTnF5zasjyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jsa7rlYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92195606A32F;
	Thu, 19 Nov 2026 02:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jsa7rlYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D2F1F000C4;
	Thu, 19 Nov 2026 02:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056546;
	bh=2cereiqLq/m6vgzQ7cQWRESzEhlLd3gsDFTqt/9l5HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsa7rlYQu02osILNaOkH7ZlVhz867jETW4zaJ/pw29RSDjPpZ8eRpkcW92m2I8ZvR
	 QWsl03yKAi+lb8L4zBqchHetT3QhhOc3Is6gg5n6HLVV69Mhchyzv52jMLhaJsknjC
	 PbB8lxLJt62gnh9QQEe4W8fuJ5ZlXwQz8gawpI4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2025/2214] bpf: Dont take an extension for an iterator program
Date: Wed, 18 Nov 2026 16:01:41 +0100
Message-ID: <20261118150131.765556631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7cc639dc45c5d3b69acb2a2fc834e9eec51e0214 ]

An extension inherits the expected_attach_type of the program it extends.
If that is BPF_TRACE_ITER, check_attach_btf_id() hands the extension to
bpf_iter_prog_supported(), which goes by the name of the attach function.
For an extension that is the name of the subprogram it replaces, so the
load fails with -EINVAL, unless that subprogram is called like the function
of a target, bpf_iter_bpf_map_elem for example.

Then the extension gets the context of that target.  If the subprogram
has as many arguments, it can use the key and the value as buffers, but
how far it reaches is noted in the extension, where the test of the
iterator link does not look: it reads and writes behind the elements of
the map.  And the id of the subprogram in the BTF of the program is cached
as the id of the target, so that programs of that target which are loaded
already cannot be attached.

Refuse all extensions here.

Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-27-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_iter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index b2ee45064e06a..d7345a3eda04a 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -335,6 +335,13 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 	int prefix_len = strlen(prefix);
 	bool supported = false;
 
+	/*
+	 * The attach function of an extension is a subprogram of the iterator
+	 * program that it extends, whatever its name is.
+	 */
+	if (prog->type == BPF_PROG_TYPE_EXT)
+		return -EINVAL;
+
 	if (strncmp(attach_fname, prefix, prefix_len))
 		return false;
 
-- 
2.53.0



