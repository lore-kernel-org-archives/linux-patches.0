Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7DC200111
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793424; cv=none; b=rS6qjjlft+KUbyZcDGjh0tSugDLdl5qaT3cp0qzCiIzpX4SevGzz3OF1fZFuYNP2W+/6QK+MoTtghTukwKre0GDysSKyMw6+v1xwRCDiUTMq+bhGhdTIi3kvAWVIvb6LSEMU3A2SSTOCZocGQQZQB76A5yCjTDH6F6qSGZz4eVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793424; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnTD9sR8TasR6+jFf2StpMNZu9tf2F/CE4J55BsDSJmLMdSWWUYBjfUcqpMwfU7EQEvUzAmCzdnXI0vJTQ2I+DPv+Mpz1pDSSoql3HuFuC7uEa2Wlv1CUOuNUyNEKc5mDSNFyP9C/k0w5ixvxnWZsYKNKi0cbfNKTydNqZeEtZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cLbpiWG5; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLbpiWG5"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fb599aac99so13097121fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793420; x=1730398220; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=cLbpiWG5Pd8bE5jrYv6Rm0cZOIk4Wh5IY9eqo3Io4wqzVXhawWPHEZulZy6eAz7Eti
         4wotdCDYlJq3ZeTdGa4XWYacmKxeGEeK8ns0COAhdRKU71iZn5ksqw6dDb/Z38oT8cRs
         9An8ltv3T2TqJaUmq2wfXy0Yp7erIIS703a6dBquWdC9UWZ6xqjOTWjjOjN3BWsq9fSM
         0l9Pf5rx0ONkjt4w8uu81QW+s6majm/Pg0qeWWCaxghlLnTsGI8HJDnsoeepLyMltGPN
         5a+OEzU8dxpazconNqxBs/iqqt6ZS2GwQwj6YO6IenoDoxU7uqgqbEplsxfJPBH3aLor
         Oimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793420; x=1730398220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=UUxVeaHB32juBYVSsdINb0EfOlGPAgXdbVB7IXuDDUIcxgTWepyR5YJr+eC9eA1ccG
         PpdaniI4MEnDx+lmIE0eRjI1jVnG2Z6TZQag45xRIht+1E7MlGH1H4pMBZdmRaT7PGVF
         H8Ua9mxzAdkMZlzMFCvQLSoBkUWSgFzOohAv3vuzyLEa6+Vb+6y47pX6lfqkj65eSiCa
         vOk97Pk2AOZkSHGSNzvg0+vp3KBYtXPXDsKg56OjwbCgSpDBAF5iTjyNxrVm52kcXU0/
         hsbXOMyP5g6ATMB0foqV3yHyxWoZWxD4IXhoB/DFfahRbp370Vk8o91SjDLn0Tkjplju
         2C7w==
X-Gm-Message-State: AOJu0YyClo1qrLkCxfoxl74VyTL/rpQcmS+WCZQ3RuQSY6/1vMHtTnpa
	rPfNM7IZUC1AVkbMgnFkpHYqnwpXStRhER94ug1ZnPXucEqluXm8
X-Google-Smtp-Source: AGHT+IGa4wOqoXH8+UMUMGrcdf2QYZr4ab9nbHTbbP+CuCHB9gOMuFBnR2m0rYD4D9s+qT7V2LGgMQ==
X-Received: by 2002:a2e:4619:0:b0:2fa:cdd1:4f16 with SMTP id 38308e7fff4ca-2fc9d32ff47mr35347511fa.14.1729793420211;
        Thu, 24 Oct 2024 11:10:20 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae0fee4sm13850061fa.100.2024.10.24.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:07 +0300
Message-ID: <20241024181007.7856-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
