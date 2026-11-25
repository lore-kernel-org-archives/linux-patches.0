Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620363;
	b=xOuYcGUiZgmouhIFY2NTMjzyLXoXVoMpf/xNVHMPTDzo/BhNWbrIQItD+eVM5t9cSdV1
	 kwBVrlDmV7+P60v50v2m5vLLCbMD7kDI3KKix+s4CgRvjkIYN795u4NGqV2BRvGvcAXVR
	 ah7JIdXV679ZfFuBa0S0ryD6duSzTMv81OksZNaCk51MRZgiGMB8RaMfpfmTBpnEnYNX+
	 ZkEwWEpkg0uJv6bnEe0urfw6GF+2HJ4oo8Ro3i/TLL3HhbXQ7IqiTodtNn7yf2ALac31t
	 k1L/584HVKRcBjRBxtYQJgZtE6J+HDubgwmG0P0AC02BuwNZEjMR0HX4vg0qIK3xczw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vMHk11DXO5vyx/ac3zuxFbtYCRoT0R0jS6wVwyly5sU=;
	b=OZ3sW7MnGEHgxodG2cX9nM74d8/OlzFgmxclep5XvnXz9TA2Pcas+lntGdtvtTCr9O4A
	 8imIm72HJEI7GMGFKMld3dYGlh4iGemN4olyJQc6Qlm+/oRin4ORrsPMJFn2wfKEqsurO
	 5eKxe6zutl0fDW1oT1sGUViCLypWRmay3lH8ZjlnhO/h0CqO8VrLq6e+mfvYVl6JHIgW8
	 sJvolUnzDC8mt+ZEheuj8nyr2ePgvgcQQJj8fvlWgq3jvSiqljD4+HOAiqWDYLFUheXVT
	 zZ9Voi7rWRwjAH9S1U8I2ItjcFmYw1AvGKSLct63WsPu2NEsq75J/XvzpBzLhQ4I6oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdJx1rLq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EAE606A32E;
	Wed, 25 Nov 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdJx1rLq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D0E1F000CA;
	Wed, 25 Nov 2026 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620362;
	bh=vMHk11DXO5vyx/ac3zuxFbtYCRoT0R0jS6wVwyly5sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdJx1rLq1CIXpiQhb75bPGJ73IzqT82MnrjJoHH1V6AiejmZvKU3lOdHbtaiRKdPX
	 +VcWLmww/qFCRKLoUMwVX3kOdTF4Fe1sZ6s5lxRzBVEM/8Pz4N29OReuNvRCX5PR53
	 7S8E9nuuwPj1zo7rJu1j6Ct9UyZ9Ss0VHF7e5L5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0885/1005] dm-thin: fix parsing of feature arguments
Date: Wed, 25 Nov 2026 15:37:03 +0100
Message-ID: <20261125143842.431757836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit c557fa19a83efad1e20eb733df821b745a4589ff upstream.

"struct dm_arg _args" limits the number of arguments to 4, but there are
5 possible arguments that can be specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 787a996cb251 ("dm thin: add error_if_no_space feature")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3149,7 +3149,7 @@ static int parse_pool_features(struct dm
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
-		{0, 4, "Invalid number of pool feature arguments"},
+		{0, 5, "Invalid number of pool feature arguments"},
 	};
 
 	/*


