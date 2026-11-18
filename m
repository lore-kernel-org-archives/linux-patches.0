Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042811;
	b=b4Q4shQsDxwoyFB1FghifPl/w+RJxsFSpORTSjfQOaAHjfRKXIGjNBynqv1Cqfw9nU/9
	 QLOezepFeoMORhgyz2kilZ0YoXqcy+Hnh2vgXi2Ed3VUvdlCHbakpEaZzf7uojiWztpo7
	 fPvzW6n8DrsQ3/82LsFBLISrhLRt0sU+7cL7kUeLhg5/peheYRwhb0UZyapUmhtplmxNa
	 ZudPMDZYvNb7II0hwUrchHOgF2gAoL8/5fpRgr6fZvUT/FJHtRf1zayHj4171jvLZLP8J
	 VAhdPHBiIsKHYzRqTr09BrcO1ZA5baEyc26KWFtB8yO/Rho/IjYBF+UaQjKnG0A+sIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UYjasaRDrPI0v6M8RR7iAT5tXi/DqLTdNJ87gVSVy1w=;
	b=iXK4DJ2FBsYcKvlKoRUcuTU6a3/beFYpM0gxRdHI85NXbFseRK3ZHBRr+JAGMDGfa8hn
	 BmJDfjfsgB8e4Tob7kYh/XrxY241uRQtExU3j/KTLglYLUD9TMA1W+/FH4Afjy2czaVYt
	 ktdF+mYmkQMXNxPIj0VpFZI9rQyqas9Ke6xhX3MY0zlaDVYeOHxS/u9qQhj4vgIZyFms8
	 BLAY3FhUFD4aBmUvEgN+I7Bf5NgVAMBMVz+t2VbUvwwq8xOA3EZsklm3+8xwii0o+5Bjv
	 aA8tP07i2wzS7u+W1MN247xPlHvJW6cjCrLc2LVlKImN/A37AHWlZedlKycGfvAoZZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxJN3618;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AED3606A32F;
	Wed, 18 Nov 2026 23:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxJN3618
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E35B1F000C5;
	Wed, 18 Nov 2026 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042810;
	bh=UYjasaRDrPI0v6M8RR7iAT5tXi/DqLTdNJ87gVSVy1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxJN3618os8VXldPkeipcJfbecHsBrmUrWBmV5TqqkE0KJeOzfiWyMzvrPAoRLVu5
	 VXz5tsIXxpa7lCM95IN/UkDA38HW+GU9+hf03RZvAYV5duSgYPG/waNuwAGO6UX8zM
	 6jL1/N45/Nlm/thHgIsolhuhxhUExc56Jw8rx5Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 3304/3318] smb: align durable reconnect v2 context to 8 byte boundary
Date: Wed, 18 Nov 2026 16:05:26 +0100
Message-ID: <20261118150458.711474981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm@microsoft.com>

commit 05f5e355cf783b30bd6eb3dec17ed1a8b3cfa95c upstream.

Add a 4-byte Pad to create_durable_handle_reconnect_v2 so the DH2C
create context is 8 byte aligned.
This avoids malformed CREATE contexts on reconnect.
Recent change removed this Padding, adding it back.

Fixes: 81a45de432c6 ("smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h")

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smb2pdu.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1318,6 +1318,7 @@ struct create_durable_handle_reconnect_v
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct durable_reconnect_context_v2 dcontext;
+	__u8 Pad[4];
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.12 */


