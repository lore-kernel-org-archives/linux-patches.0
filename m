Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022719;
	b=LYK1/Qimvb+r2c6CTJQBWS3nwp84rbxWtAIUe0EvuQ5sFNmxVOk4cCfkVluUMvMfaeSa
	 tEFsXqBCr/npdveJTAOJjhjzn2/okSGzAabyTYsjavNwIrSXI/bMaeVLoDWpQWSxxQ2N+
	 m4ejK0iSu0/vsawLHbMh2INe49kjO+wmSIdRjU4ApSjwk4l6So6iaF+/Z9AM46nOPEBqb
	 MnyAI+KmVcgOC1Fdh7AOjfUn5yLKPKGDbkvpPXXNh1Xxfet83mkOsiX+TkVw2EJPPw3ux
	 OPyj75EY9zFbTqVBNNEyxGx4UlC/EUVqC7R0DF8c2Vffv4dSEpPJf8k/pSQuVa3RLkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/0m5wVLzQ5p93G8NxYQYvY2AhV+1Vy3VS+pnaYjgdEQ=;
	b=IEO1P1Jfm15WXf1dzW1NS71VHFNHYWeI14RTzhKs9mjyXZ59e6aG/AiepHw2CAb6f54R
	 7Q1Vx9fUswObtCswwGQ7nzM9f6pRNmMYtk1UvnnZgN42sKqdG2teyIdVrGzFtY1IvB74F
	 GfTuM7RsQVN3QvjShhGhY6MSzzA5B50ruOoGEFr7HGbRM0prNuXDakcfzWJ/dvn/hDa5l
	 jy8I/kgVvz1dvkqtiGVqNgedbyJAkf9UHXJDeCcwGtt+TF7CaWJjHTpUyeyrfnXut5fdR
	 rNIf6OXlrF0icrCa2njASpOK6bpY6TH/spz3raFi0E54SA5OmkGt9cGLfXqUbWGqjFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d5pcQ/Z3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DBF606A31C;
	Wed, 18 Nov 2026 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5pcQ/Z3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594871F000C4;
	Wed, 18 Nov 2026 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022718;
	bh=/0m5wVLzQ5p93G8NxYQYvY2AhV+1Vy3VS+pnaYjgdEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5pcQ/Z3MKUPuTZhu3ZABSyYrLqHoCQmkBPV2VkYiAg3Cv9EMHTGJgwaDM6yfIQxK
	 S5Z9XAcNYzpvTefvCE69vQb88QxfcQ/XG5u3afBTdsRatUzSqJusgzrPmIbS3MKlzX
	 qojEulMT9sxdASyvnTRDQW9GjJd86zNiEh8JoG3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0113/2151] rose: give loopback answers LCIs that calls cannot be given
Date: Wed, 18 Nov 2026 15:30:48 +0100
Message-ID: <20261118150125.911547681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

A call to an address of the node itself goes through the loopback
neighbour, and both ends of it use that neighbour. rose_loopback_timer()
gives the answering end LCI 51 - i for a call on LCI i, so that each
end finds the other. The 51 comes from ROSE_DEFAULT_MAXVC, but the
number of circuits is the maximum_virtual_circuits sysctl, which goes
up to 254, and rose_new_lci() hands out LCIs from 1 up to that value
on the loopback neighbour as on any other.

With more than 50 circuits allowed, the call on LCI 51 is answered on
LCI 0 and the next ones on LCIs that wrap around to huge values: the
answer is never matched to its call. Below that, LCI 51 - i is never
checked to be free, and only the way rose_new_lci() walks the LCIs
keeps it from being one that a call already uses.

Answer on LCI 4096 - i instead, at the top of the 12-bit LCI range, as
was nearly done before commit 1f731b63752d ("rose_loopback_timer sets
VC number <= ROSE_DEFAULT_MAXVC"): 0xFFF - i. That commit moved the
answers below 51 so that /proc/net/rose would not show an LCI above
the number of circuits; it prints the LCI on three hex digits, which
any LCI up to 0xFFF fits. 4096 - i is still its own inverse, so each
end finds the other as before, and rose_new_lci() never gives out an
LCI above 254.

Fixes: 1f731b63752d ("rose_loopback_timer sets VC number <= ROSE_DEFAULT_MAXVC")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit aeddd6cb7ca6e8019ac73c8c0d40e5d9dcbc5c6f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_loopback.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 6c5c35030e67b..efd4a719ab2ca 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -101,7 +101,12 @@ static void rose_loopback_timer(struct timer_list *unused)
 			continue;
 		}
 		dest      = (rose_address *)(skb->data + ROSE_CALL_REQ_DEST_ADDR_OFF);
-		lci_o     = ROSE_DEFAULT_MAXVC + 1 - lci_i;
+		/*
+		 * The call and its answer use the same neighbour: give the
+		 * answer the LCI at the other end of the 12-bit range, which
+		 * rose_new_lci() never hands out, and get back from it.
+		 */
+		lci_o     = 0xFFF + 1 - lci_i;
 
 		skb_reset_transport_header(skb);
 
-- 
2.53.0



