Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017283;
	b=BZoTSuIFmPgSdnD+OV2Jkg0Px67laucILNtRZlqbXGEgoatJYlMWRQdJ3WaviLBws6qC
	 6X4OlKXafhHmHMs43Ch0UjdByMJ4Gq67nurHWTjpCOWRyE9OfM5SP6ysU6mNMe61yRXIP
	 kUIW5MTetQVaIcQf9z0fcAd/adRAJxj+hl4Y+g5fAi9i7aAACW0ftIQfcr9PCKKspfoth
	 +UzHtL+cMXoMhQkKHDuBAe3mpuPKui8bW6LwyBOZjesPQyoLlRiQj4qi7nMbFqFFyrPMR
	 P7Fr7Ofxd7mfZ/TH3cJAN269DKJSGagFA80zkOwZFC/R4y/GqSyPzIN7QWhyNtJ3aDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OjEVVM6QCtzBMVnj5/ROGrVL8TTmm8eRx3aABSj1uEQ=;
	b=aYVMBBiQ6iDxUSbPV0itKkDoYg/UtfoldpRVmQKLyR55gZTrq71UzQk01A0mkMH2IBXF
	 soqUwNnhcgBIoKOsrXASkLE0ni9PSSYFVMl0STKso4OXrUU4V0gkIpppOQEZpAbd1qDKE
	 uW7gEn69J2J7RLwMiIrWmbqbSNMJfuoZ4p+Hrsr236Etg9LVR5nVP4grEwZhAjtyOKCxl
	 OBtL3aavKNAof3Roxog6geleRJ6MKtZ0S3cNVh0X1Dh8yjJ+GNMR6myOdPxGBGWhugUWa
	 GD8dHjyXGtrCcaSUacXU+SkDTpxQ9IV/I0qT7KV7ggXqLKYrEIZnaUgyXgZGIWN3gkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gP1qdUGb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5376606A334;
	Wed, 18 Nov 2026 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gP1qdUGb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAD21F000C4;
	Wed, 18 Nov 2026 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017283;
	bh=OjEVVM6QCtzBMVnj5/ROGrVL8TTmm8eRx3aABSj1uEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gP1qdUGbg9BLu6ruorrka4SM6hLPVjQx+e4u4aORZKgvKA4kCGmqLezomORQX5U2c
	 a//NT8XPdjX3SR6umuJDp3OzoDjuczB60x7i40EdandpN4TctLcp6L/fp5ZdOkgoSA
	 N8QXIqcvrHT5bJf/66EfbncBHpx8iUDFiMsv8Msg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0788/2651] bpf: Adjust bpf_func to account for CFI offset in bpf_jit_free on riscv
Date: Wed, 18 Nov 2026 15:33:48 +0100
Message-ID: <20261118150316.256184016@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 93df8ae3267f19bf0c1135d26a0e21145dd0ea1c ]

When CFI is enabled, the actual BPF program entry point is shifted
forward by a CFI preamble. During bpf_jit_free(), this shifted pointer
causes the wrong ro_header to be fetched, leading to a potential invalid
memory free.

Fix this by subtracting cfi_get_offset() from prog->bpf_func to
correctly restore the original JITed allocation address before freeing.

Fixes: e63985ecd226 ("bpf, riscv64/cfi: Support kCFI + BPF on riscv64")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20260923144216.934701-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index cbfcd287ea166..059db1adeaf8d 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -237,6 +237,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 			kvfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
+		prog->bpf_func = (void *)prog->bpf_func - cfi_get_offset();
 		hdr = bpf_jit_binary_pack_hdr(prog);
 		bpf_jit_binary_pack_free(hdr, NULL);
 		WARN_ON_ONCE(!bpf_prog_kallsyms_verify_off(prog));
-- 
2.53.0



