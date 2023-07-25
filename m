Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD61ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C15C433C7;
	Tue, 25 Jul 2023 11:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284514;
	bh=XnvtDfwSlEEkQMSoYckVxHKZRH66ois/0geTS5fp7ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGYWyvGxYr4ArUdkGVGgwlFbOGZXU1gMUcLUH8JCifdCmZ61UN3qxloi/0kYcDDfp
	 EE0itKj/6q2i3IyrtGqVzQFyLfZEbElFtfWwp/WxaniSXpjqRGeO+nzvNcjnLSDWTc
	 2kEK1RLOht3IwZDYy6Q0UDT3dVjavOuy1MQFniPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>
Subject: [PATCH 5.10 384/509] misc: fastrpc: Create fastrpc scalar with correct buffer count
Date: Tue, 25 Jul 2023 12:45:23 +0200
Message-ID: <20230725104611.322987272@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit 0b4e32df3e09406b835d8230b9331273f2805058 upstream.

A process can spawn a PD on DSP with some attributes that can be
associated with the PD during spawn and run. The invocation
corresponding to the create request with attributes has total
4 buffers at the DSP side implementation. If this number is not
correct, the invocation is expected to fail on DSP. Added change
to use correct number of buffer count for creating fastrpc scalar.

Fixes: d73f71c7c6ee ("misc: fastrpc: Add support for create remote init process")
Cc: stable <stable@kernel.org>
Tested-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Message-ID: <1686743685-21715-1-git-send-email-quic_ekangupt@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1106,7 +1106,7 @@ static int fastrpc_init_create_process(s
 
 	sc = FASTRPC_SCALARS(FASTRPC_RMID_INIT_CREATE, 4, 0);
 	if (init.attrs)
-		sc = FASTRPC_SCALARS(FASTRPC_RMID_INIT_CREATE_ATTR, 6, 0);
+		sc = FASTRPC_SCALARS(FASTRPC_RMID_INIT_CREATE_ATTR, 4, 0);
 
 	err = fastrpc_internal_invoke(fl, true, FASTRPC_INIT_HANDLE,
 				      sc, args);


