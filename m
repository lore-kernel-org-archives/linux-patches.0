Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061847;
	b=zDK1pZr7wj0GxILmpyTM2PGMCdFeMH8YTXsjcfkRZ39TTylfNoVhgYxUWwynmg8tnfCI
	 1qEZZuc67Rtf8vIzuyYs/Jcx/R6SHsankZ+at7y3Rppt5sPwiFGm0ptjgnqrSc1byu7ix
	 Wc8qlgcRVWZctImREfHi2HhKfWFESrJZgR2Koo4oJkhJjpO+2QMAWUunrPBh15q+f00+k
	 BlTlmKgeRuUlh+vfHVjt9ChpDNRCtZ6F5pcbcvtgbNZAPTa9XrsIcCj9jtAQottcTW0Lz
	 QO2o86wAb3tW5Nm6Cz2Jd+kzVMBhSDhFrdc2YoPn0Ua/kUa8UnQTY7H6iyK8g+m9pMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wnJ3gkBVP3mGdaqzFzBV4LOfqPvoinSIg+/rUx4ZArU=;
	b=166ahZl9wXbeckRq6XRorKsfb3Mvk1avzL6qyRlcMX2JhJIvrI7Adkr1hRi7gDMoU5zg
	 OXNydJdmMgFkL+kHYRXKUh+iE4w7H034XH/XurXyTZFiUcALznSjWSqYITjlb4cWAX7Nq
	 BmTSQF9GivN/dRn0NoMRFKb8LO9A0jBoDDdzYAdXq3A0RF2TkgxzrFtD0RXmD5fmyMvR9
	 eUMaR3gzWOJdRkDGy5Y4UkwXB4fwo2ExQmSg78Pwif8rmTczTwDA4/nKZSQsQalnvPolA
	 1r6DtTYkOGmlOLsD4JmyiXvkwG6MPFiarZ81qo4/dAS3y6L+7ikqn0v0/9KnJAlD6hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zdpLn/ys";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03581606A325;
	Thu, 19 Nov 2026 04:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdpLn/ys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CE51F000C7;
	Thu, 19 Nov 2026 04:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061846;
	bh=wnJ3gkBVP3mGdaqzFzBV4LOfqPvoinSIg+/rUx4ZArU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdpLn/ysXC5slbTEA1jiC+twpxV1lCF3MZIWcj0leysda8rdQFMpXWLQJFr5vZHoc
	 vIpFzZ6ScDmBIThmg1essAi5ViRfyh0GLqBlVYYsMR+rb6L9wOqzg5aD2z3bigfISb
	 EXiZXQ12zdKj0WGNEfAEOZWvGzAGhrMiZyQOq7Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1700/1848] bpf: Dont take an extension for an iterator program
Date: Wed, 18 Nov 2026 16:02:18 +0100
Message-ID: <20261118150030.915812310@linuxfoundation.org>
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
index e8957e911de31..73e9b584275ee 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -321,6 +321,13 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
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



