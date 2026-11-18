Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017289;
	b=bCPpHAKE5Hxe/DkMCeqzNBXAfXOb1OPD81qgIlryjAGY8Oel6jGXXzbgR1/TRiNdixnP
	 kRvnLEq5Qy2HNszbC/5VsJ0JBjwxtRg6viD6WhBj5XzpmxEJrXD0DLXuU6q86HTvUNvYE
	 iGJHTNlGYouvunyJERAOACqwEDVNOgseXJqjRT33SHDdqCRtuQlAj93RGVcFL0SRDj2U4
	 AZOxDIIukNWtEDdOLrUJoYvYQqwjl9w1LWozftM3GOt48WtosI2eeI9qRJqu16paoKihG
	 wE2vFNtxMvjZPbwMd1nDXIHRQ9Gw9BfrLdoAhuz/d+RUAjGQoM1+vhQuoFEFQl19Vpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvkX3RKj7wMA2h0uFFLWF8hXEs7LZdsIU3MDtfIdxoU=;
	b=BHpo122vhg4QnzX19tLKVxvSLFliDbePdEaqKxvHalT9E22781nmXQtfCLN5iDpXLqZq
	 wN0H3pvSjAkIxjVRdlmsRS2Tew1bA7+t+NMjUaJsVmYfOyCmLERBf5hLKMfqYQFKff426
	 zrdsemqp2TpKm5gakEuyx5IPidFMiHJWHp+1K8yZXyUcp74ZNd/nFyfua8buY1iMkn107
	 ljGVeGfgTakKIX7hHRiOQPzFYedmLpVTh9vZsejFrO4Fjvw6YiXI2pnwL0/3VX7bJcf7b
	 cGt//2+KDub439FJnpSkFBiaTut/OXGocrq/B2dIiXib7jtY74BTP68nMu84/Knop9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMORciu4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7117B606A320;
	Wed, 18 Nov 2026 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMORciu4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB921F000C5;
	Wed, 18 Nov 2026 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017289;
	bh=jvkX3RKj7wMA2h0uFFLWF8hXEs7LZdsIU3MDtfIdxoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMORciu45FXN1E7hN0TszxoHHAP86ROHQ1vu1X5kRkRTf/lD5PTJeRtCpB1+TfXcJ
	 NOX2dVzZIxhshmVsJQ3hjssDmu6xuvJLy94UTi1a1Rzj4XSKpKrE2PAb1eFbu5410y
	 8IkUK+jzILuwXgL2jCr/bZYyzEYTY6wpIR0SIM4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0824/2651] perf llvm: Fix memory leak of args->fileloc in symbol__disassemble_llvm()
Date: Wed, 18 Nov 2026 15:34:24 +0100
Message-ID: <20261118150317.556089795@linuxfoundation.org>
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

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit fe529886843f451ad6da7e65d53325432e0f80fb ]

In symbol__disassemble_llvm(), after calling llvm_addr2line(), if the
subsequent disasm_line__new() fails, the code directly jumps to 'err'
without freeing args->fileloc, leading to a memory leak.

Fix this by explicitly calling free(args->fileloc) before jumping to the
error handling path when disasm_line__new() fails.

Fixes: 04885681788855bb ("perf annotate: LLVM-based disassembler")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Cc: Steinar H. Gunderson <sesse@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/llvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/llvm.c b/tools/perf/util/llvm.c
index a0deb742a7331..dc66f6cc1db65 100644
--- a/tools/perf/util/llvm.c
+++ b/tools/perf/util/llvm.c
@@ -254,8 +254,10 @@ int symbol__disassemble_llvm(const char *filename, struct symbol *sym,
 			       (unsigned int *)&args->line_nr, false, NULL);
 
 		dl = disasm_line__new(args);
-		if (dl == NULL)
+		if (dl == NULL) {
+			free(args->fileloc);
 			goto err;
+		}
 
 		annotation_line__add(&dl->al, &notes->src->source);
 
-- 
2.53.0



