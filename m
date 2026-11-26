Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705617;
	b=2KQN3mDubcLn15c7SaVqLvvMX/d3RzidWxxEJC+TY07m0V7aZnm6+bf8nwSzygffQKtb
	 pJjFDaV22E3bnEltfVZZVYJhqY0v+XJqf7K6fgFcLF+wjbkGiOpRguhVMRhTdxfG9ayZy
	 RTaULYzZuG6dRZMICvr1cuAt1WsWox6jFA/uOxEAkyayY7X0M1rjc6Kbs6+i2g6yI6nXr
	 d18jEM0D/96Wz75+XIQ8ysNSnioil2FhIiQ4FvUKctzcjzDBjJcSTxs7pfBA/nN7oywyh
	 lye300QBOe0rgzPgkuG0xLuLLD8h3M5BE46CIY6elcacivNQM7rvgLE+C/bxair+K0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhdZ4lBuEaTd/hFoeJ/HasmpG/n3HvVs8zzS6gOtsdU=;
	b=kfeMACc0S/iilE5lSxH7IG0IDE9G912+OxvAAUf5h8/HNp5bd9YqpvbHMZ1hsJ1m7ceR
	 ErHxSnXjZSnYayKtKTUQHE6F9ta6wT8CjeSIGAjh4wK2HIMnOiyv3mYLuK9M3wDLTvO79
	 zCbNopL9nnQxIZt+DAfjZ9Dcu21mGUhk6L2XWFBiLr+E1rUEXnVWOnMvzmXqaDRC2JaHU
	 da/iBw+e258uEFVyli6+CE2AXpHeKIDDT1E79TgnaKSXraSKESO7TYpyfetO7g5xqZ6zV
	 /Rk8dC5x7RtgMz+WdW9j7YYaIq2PeYCOQXj3T5ZC5T68+cetg2izvMbypJ6PTIllKag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfl14awY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4502606A31C;
	Thu, 26 Nov 2026 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfl14awY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5241F000C0;
	Thu, 26 Nov 2026 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705617;
	bh=YhdZ4lBuEaTd/hFoeJ/HasmpG/n3HvVs8zzS6gOtsdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfl14awYldxlwATDaWFDCKOrEqbrGkp2UJSSeCNRSu9ZNo2ZBNXqA1RKQpRSjoLUk
	 TVrSXTJ3dB4S+mok8FSEg57qFyLzMG3WHb+LMrx1RAofgE2S7vqHrGMVcUblRtG6Kb
	 Sq5/a0yHCjetF0+irp+QuNbPHqMreO2GCqRAACi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 257/319] dm-thin: fix parsing of feature arguments
Date: Thu, 26 Nov 2026 15:40:25 +0100
Message-ID: <20261126144012.547876704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -3141,7 +3141,7 @@ static int parse_pool_features(struct dm
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
-		{0, 4, "Invalid number of pool feature arguments"},
+		{0, 5, "Invalid number of pool feature arguments"},
 	};
 
 	/*


