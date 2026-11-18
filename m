Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034314;
	b=ksBnACLG1ZgiZgNy9rTaGZqe69YaQUq/OrAeLUJWyob98Gkwv+tgOtp3NC6oe2TOG25C
	 Fb88iAjbOT7bYThXKXyAZR/NGT0v0LMjVTcbOXwly2ZYUNpIzdPmPIY+9vWKQEuVrLwY4
	 U4M0s4adja0KCcoZt/aH90ZzWOS6508RFyMdPwvCpjJU48qzMX30sRaENiTmiB8m/JSlo
	 b9hF5FVwT1TfSu3XbHR3aCfJ1yJAwDVOMCNUX/i5tmau6qDXhneuLglv1V6kiFFm59IK+
	 DwHxejB4VY7CHskTsUqkfjXnNoLlH9w/FfR8zO93YSNf3+r2HaLkz4J2JRNmP0AxwpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rVghbHCD9wyO0X5aD/zPhqgXM+Gx9N/Z2HYewoiR7W4=;
	b=zd6Eslu13x9J0N0OcIYr8vDLWn/ChjywmjQT1IuxuOnELPrgGJOupyjfU6kRSzXdLYHN
	 kCh/P6hsxOXHjfbM52vE8psvFZvCMuYbXzfOeyUXulbkjx0rWRFxaRikz2UsCEqP7xNNu
	 Su9FftJiMFhu6eFy2+zVKspEH4KQ/yDWnxs2VHuqD5B7gcvbwAL0o2SmSIqN0Nh8syRyb
	 7xwNL1sU9YIRQRwHY+5UWFUFNg4rJZEMFFPpi7OipqD2Hk13Fqfgoletxdhy6HcKPJ2Ja
	 H/OkDHMRKP7CJuxCoe1N6/3+NvGeS6q4pDSmw0CbSRRAfRVeNXWAmU6QnyC6HuR2RBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l13MjKCO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6A5606A32A;
	Wed, 18 Nov 2026 20:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l13MjKCO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FC81F000C4;
	Wed, 18 Nov 2026 20:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034314;
	bh=rVghbHCD9wyO0X5aD/zPhqgXM+Gx9N/Z2HYewoiR7W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l13MjKCOLs6GNFr8xBBF/Qs+MHyEdofy5xGwvnqscmRatmIAthtg6DlqoCffYlwnA
	 MnsNv7BmYfGa01QzOAadFuZfYZ/ZBX9AMT7w0fsgJJ0am4aJTkO4IM+SkfeuRNHsSD
	 ojhthJVMEl3l5fs7eOiUqUgKN+NGCTk0fNFOGw2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0288/3318] ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
Date: Wed, 18 Nov 2026 15:15:10 +0100
Message-ID: <20261118150324.228306560@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit c1d7bbfc5e081875053723d1a69eb2cf341eaaf1 ]

When a client's Durable Handle Request V2 sets Timeout=0 ("let the
server choose"), fp->durable_timeout was set to 60. Every other use
of this field is in milliseconds: DURABLE_HANDLE_MAX_TIMEOUT (300000)
in smb2pdu.h, the nonzero branch immediately above
(min_t(unsigned int, dh_info.timeout, DURABLE_HANDLE_MAX_TIMEOUT),
where dh_info.timeout is the wire value and already milliseconds per
spec), and the scavenger in vfs_cache.c, which adds it directly to
jiffies_to_msecs(jiffies).

60 is off by 1000x: the handle becomes scavenger-eligible 60
milliseconds after close instead of 60 seconds. A client requesting
Timeout=0 is relying entirely on the server's default to cover the
gap between a dropped connection and its reconnect -- 60ms is not
enough time for even a fast network blip to be detected and
reconnected, so any real disruption loses the race and a subsequent
DH2C reconnect fails with a durable-handle lookup miss instead of
succeeding.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 503f3219382b6..d52e1f1aeff59 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3668,10 +3668,17 @@ int smb2_open(struct ksmbd_work *work)
 				fp->durable_timeout = min(dh_info.timeout,
 						DURABLE_HANDLE_MAX_TIMEOUT);
 			else
-				fp->durable_timeout = 60;
+				fp->durable_timeout = 60000;
 		}
 	}
 
+	/*
+	 * conn->is_aapl detection above (this function's create-context
+	 * parsing) is skipped on the reconnect path below, since a
+	 * reconnect always arrives on a fresh connection -- if the client
+	 * cares, it sends its own AAPL context on this same CREATE, which
+	 * this function's normal (non-reconnect) parsing already handles.
+	 */
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
 	opinfo = opinfo_get(fp);
-- 
2.53.0



