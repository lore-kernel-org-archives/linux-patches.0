Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057416;
	b=if2KTqJBtA9ip8kftqJME7bvuFu0C7cP8KR1C7fLy3f8lJ+VT3tU/gDPqUNBxO3AJyxC
	 aGoDgZE/h2F3aZhm3t2hI5PR0sOg3LgWkGbniYWhyAkGTn3mpHbk+dqHTXCzh6qRxi6mU
	 W6Y8b+klwB4zgx0iqctBnpwFcUOuoKkhLSy+DzKh87ibOu6K6JJiV2GjIbINkh1Q8EW0/
	 7cOVoT0fKY0HJEE9z6voLtNDkRO2w/bOMRRy7bGxcfWCtZTdlrdgCXcR6NLeeakf24rIX
	 YwgdikJzQgxvi0JiaOpV7jPC9WZpwH9m0eAqZAei8xtWs1tH6qVAzxqWqiRDPNP6ydw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yWeFmKpf7V4NAlty8gu+8tdomGnmZjxC3NQFg9PEeaU=;
	b=n5L7+b80qCQC5WfJ2uvDhCy39pkUKe5MZDGVWvUT6eUrwfSiRcjSJQceIXn32c1adfvx
	 DMUEk7UZWOM1Bq/WAcF9db6izrwUobi7Q5ygJOdkYcrs6cLazOGiIyRUEBJEbE2LGQGCd
	 BVUbMD2L2TM2lwnp81vjZZCty960bfd51xyO20mX697kzhfUC27wn22cx524A85PGck8T
	 PSeTRjmwOA1wwfwnGtt48KjumszdPe0dg/CtfW0LJvMdintOHKphC/ZjOK3ySuoqYn5pM
	 7P98uRi9dhTMmK4rgKTMVAY5oL/I5dhJ+8y4iKttDJq0p3nchZrAyzzDuNDcfHtsbNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2JFYzu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B95160A260C;
	Thu, 19 Nov 2026 03:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2JFYzu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8E41F000C4;
	Thu, 19 Nov 2026 03:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057416;
	bh=yWeFmKpf7V4NAlty8gu+8tdomGnmZjxC3NQFg9PEeaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2JFYzu7LpcJV6lohn11zROt7R5e0SeoeQJOXpeexNxwLxEYLXjHAxkMaubT3Fniq
	 RhJZnarIk70tuMqbZh1eCEHrcGYQ1Dcpot4ioYUo3Qp337d9WSpoA14aE48anmPdaW
	 x/WC0kKzG2oyzgOf5KhUx/dFUgB8ePMxAbZtamdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0096/1848] driver core: attribute_container: Unwind device_add() on attr failure
Date: Wed, 18 Nov 2026 15:35:34 +0100
Message-ID: <20261118145915.129914518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8cfe7ad274bb42c4653b645267410d4a3a23db98 ]

attribute_container_add_class_device() first calls device_add() and then
creates the container attributes. If attribute_container_add_attrs() fails,
the helper returns the error with the class device still registered.

Callers use an error from this helper as a failed add and do not call
device_del() on that path. Undo the successful device_add() before
returning the attribute creation error.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/attribute_container.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index f7bd0f4db13d8..95cb92ecc0a8f 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -455,7 +455,12 @@ attribute_container_add_class_device(struct device *classdev)
 
 	if (error)
 		return error;
-	return attribute_container_add_attrs(classdev);
+
+	error = attribute_container_add_attrs(classdev);
+	if (error)
+		device_del(classdev);
+
+	return error;
 }
 
 /**
-- 
2.53.0



