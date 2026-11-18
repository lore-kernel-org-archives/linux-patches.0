Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015930;
	b=N6zpw9F0kVjFSo1eLghOD+2OYUkb43snM3e7AkvBIKGMRtjYRqSS713Cs17ePz5apL4x
	 NFTXa/At9sq+T1kqSHm2tu1Vlliilag0mdpDMwNlPMrvIcppCNAeBFAUbmYfy5NFfj+yQ
	 ek6NNxJesSRjBEvPHw9n1BHvdJoI61ZDjLkro90/k0cYXI4YdHg1piTWvTWKzZJr/lEqw
	 UjPhCFSJKxt/d0BCuPns7uiFCTmlrqPhrHEq2Q76YlJJhr+3KGCvQ5934qlK14kRA2K0T
	 wRTY4zGgJWI3LGu+1bkTuxB+AJg4AmSr+P/WKkxhS8QlA0pwxq5/HkJ2vTIrz3sh6nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qYqa5+5epiDWS9xKJIqET1CsFJCnXt15wUmhDQuj3YQ=;
	b=cpC+zCijGhBjafUf8DoV2rhpCMyckuTrGIgOcIESf32YJ/b0mKeN3VK/6OS1FA8BCYv4
	 LPdBkDtPhcjX2Ut/j4z2KtyOzPInyu9Q7RHO7j8qqASMBaGdg9uvbD4MaWszsHvw9KrVJ
	 IhdyYFA+ABhdokW1dKplJkWAgRPMkgON7R0sSFXajPud68iVgK8BquXURVl9alJ6ugW2+
	 HceKs3L8DeEOdQtXsb+dFBiCo4vMyjkSVLdrCbYm8p3ldzN1QXE6arYP/jvxIi87mkulg
	 tDDw3PtRocniJiBfYItjchzoTjgtjEPoRonaFkCnDfvQMli3jnwgspmK0PIQMLqn22w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iT6eimVE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CB1606A32F;
	Wed, 18 Nov 2026 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iT6eimVE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906E61F000C4;
	Wed, 18 Nov 2026 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015930;
	bh=qYqa5+5epiDWS9xKJIqET1CsFJCnXt15wUmhDQuj3YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iT6eimVEgHJXINa69gWe7C2zR6NLShislfLu8VtvD8Mb9TTt3J89bsMxNs437ZVvd
	 N576bE2IAMkx1jHb7/bXcDmUh3wr+n7GvfMG93Nvtx5zQKmfDFzl0YOg7REDxPGfl+
	 DX4Q5NvX6sA1ClU1M5ZiK3ntwgUAEPCKWOuNPLHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0349/2651] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Wed, 18 Nov 2026 15:26:29 +0100
Message-ID: <20261118150300.402471397@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c12a3a4b35e47fd511fbd550d3637318be41c4eb ]

efi_set_event_at() documents ids although its array index argument is
named idx. This produces missing and excess parameter warnings.

Match the argument name and fix the adjacent spelling of array.

Fixes: 8c0a839c2bcc ("efi/libstub: Descriptions for stub helper functions")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810..049263a541aea 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -224,8 +224,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
  * efi_set_event_at() - add event to events array
  *
  * @events:	array of UEFI events
- * @ids:	index where to put the event in the array
- * @event:	event to add to the aray
+ * @idx:	index where to put the event in the array
+ * @event:	event to add to the array
  *
  * boottime->wait_for_event() takes an array of events as input.
  * Provide a helper to set it up correctly for mixed mode.
-- 
2.53.0



