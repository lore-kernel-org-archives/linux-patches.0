Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68171FF02F
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793417; cv=none; b=hb69A1waPCE2nlkQ1eOnwgMnI55teY6AR35uWhYE0mIbON5cTe81ePs1GDlOssZQTQJQudoRKUEcf9u1IqVrnnbnRPbrpL4d+TBFNPIDGHGBowIbyXZ4Yi6ncBnO7DTDYq26sN4nPPdYzRksKsIDG3GlfVJHOJzjUrUbs6N654c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793417; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSUunMhaX1I0rtI2kput1uW/6pWPefREippLz50DQTbmO2FYpyVBlwlveHyyzkN7zZZNKpRpM1ws+KhgSdGhN+OMCraorToh+A6Omll/tyolOWLMsIxXMipNZVy2+9UtxpuGO+k+y2cl1Ks3lpnnqmyytCUvAl74crZKVnO+8Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O+WyiEy/; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+WyiEy/"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb5a9c7420so12985901fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793414; x=1730398214; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=O+WyiEy/UTruA+yVGSjsjTbCS3QQ71c+8gsmwcWyGnyvAhuqdTtE92OwjpgMovpdKy
         +jj+eiB14ppPB5RNTVmWSLqD2vUsPF9x7XabSNajT0MA5Qz2tDBuzSfjcEgej//ppAUi
         aHr7K5+FrhFnckG0SgN1lvM+KuHhroUJHfAATNbpn7vM1Moiz8w9j8/ThW5GLkj8orCK
         ZgaB8pBjSL4Vf5d8qPMf5DDK7yvAbtrGmTxEHGs7wWZ/1RNJIl8S+32CitvIsfH70DCd
         RWyykmomcGuziyypBAlPGIYirf5rYUfyMb6WldmFsGY7th33JLWZqBuOdZ0m1knBxsyC
         bCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793414; x=1730398214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=GmAvuyIj/7qBslG46YANl+VSt6i0tVmFiYX0e5PEvbHFr5h7ZYGIoA2Lg4iuoyY++D
         sf8q5jyRO20Je6P6IoLUppEbOlJFllbX8dfVxor5RWUeQhEvzUylVpGEzbGLCZPfYEll
         40VvMBzEyqgkTZzxFu/wFcVj0NVUF2gI2UHyl/3J/EGiNfxAPzhGt138XuBGeJ/9/7bZ
         3s0Yv37J2Pswa6kSdLP6Xq1UYRs2e5doXUveGT/25qgv+HEh0HxTfFGEcAuCDHgwgwiC
         Z6mroM6SaoQCzXfZqqSvuBKDW8/P7GcGVR1ORN98WJdBueKbs0AZPp7QD6pVAc7tgcwN
         JObQ==
X-Gm-Message-State: AOJu0Ywknv3Bbt6laYPHdE7+gqUe5kDkRk0HL6hZDsr4C4oUjYcfddrW
	3MAXSdW3gZ+7H5oqqgDuCbn6TlYiN28QEv99rPYxaEK2EdmTIoui5pzAqD7P
X-Google-Smtp-Source: AGHT+IHblVX0CghBiVduWbOrYkG0Q56XQ4MH2BgeIT+Uc/wToI7ez+9l/tLMhqSAbZLwp3gmo+NBcw==
X-Received: by 2002:a05:651c:2210:b0:2fb:4f8e:ef9 with SMTP id 38308e7fff4ca-2fc9d59581amr34292061fa.30.1729793413632;
        Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad60629sm14654521fa.37.2024.10.24.11.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:56 +0300
Message-ID: <20241024180956.6269-1-vladimirputin693389@gmail.com>
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
