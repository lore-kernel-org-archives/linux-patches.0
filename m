Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D70B403AFA;
	Tue, 21 Jul 2026 21:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668498; cv=none; b=H0j4gC9t+tBmOqYvemEpjT+1zi6LVAOo9BuAVnl6mYsFgJ0sxPgBn7FEOdrtXlg7F4mVl0DH2SbiZUwkr1frhMiApiT4raIPx+eSkfnwoh0n9zIIFgaAfsb3T3s0pjR9vifvhqWYd5kZU6VISZsL4fEOHHUOn3EcyVJK8/aZw04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668498; c=relaxed/simple;
	bh=ckG31L3xNAADpIbHq50Z7lF2bOxdJVwPOXcVb9NXnb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKBC7CExTPYIpsabhkURTopez7BwMl64GXzq6ha1LfsCrKNDWAPkj3dUXlvFXirJlQl4Jh7MIdDvzJEwqq6i61fzLXh/+8FFpvAutM+oxvdgQDsoXX/2JAfy8UYA7Uogg2gyb4FbXcIhSZjP8wVK3EOnb6elCZHYLwd3v8bClys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYZEmdrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYZEmdrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756741F000E9;
	Tue, 21 Jul 2026 21:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668496;
	bh=7XNGfe3KWhQjkL10bSMwh2ODOQHd00/LQkLIjy2jtk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYZEmdrSgY5Xd7nPegSj/UChi1WSEVXTu74Hd6C9SloMGIKVhSAdhLzbAxU+X+P0u
	 OjfUdaI1hRB7YgsdrdDvsIipD/w2aBtixI2bFRge9ZrKWDZv824nLPVCdBLivak2ut
	 sLCwu/Feh1ADBsYVA+/rBuaJxruYX1hsUTSfebao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0145/1067] smb: client: harden POSIX SID length parsing
Date: Tue, 21 Jul 2026 17:12:26 +0200
Message-ID: <20260721152427.840427421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

commit 7ad2bcf2441430bb2e918fb3ef9a90d775a6e422 upstream.

posix_info_sid_size() reads sid[1] to obtain the subauthority count,
but its existing boundary check still accepts buffers with only one
remaining byte. Require two bytes before reading sid[1] so all client
paths that reuse the helper reject truncated POSIX SIDs safely.

Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4857,7 +4857,7 @@ int posix_info_sid_size(const void *beg,
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);


